provider "kubernetes" {
  config_path = "/etc/rancher/k3s/k3s.yaml"
  config_context = "default"
}

provider "helm" {
  kubernetes {
        config_path = "/etc/rancher/k3s/k3s.yaml"
        config_context = "default"
    }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }

  backend "s3" {
    bucket = "website-blog-terraform"
    key    = "state/argocd"
    region = "eu-central-1"
  }
}

### ARGOCD ###

resource "helm_release" "argocd" {
  namespace        = var.argocd_namespace
  create_namespace = true

  name       = var.argocd_name
  repository = var.argocd_repository
  chart      = var.argocd_chart
  version    = var.argocd_version
  values = [
    "${file("files/argocd.yaml")}"
  ]

  force_update = var.argocd_force_update
}

### REPO CREDENTIALS ###

resource "kubernetes_secret" "argocd_repo_credentials" {
  depends_on = [helm_release.argocd]
  
  metadata {
    name      = "rootapp-repo"
    namespace = "argocd" 
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    "sshPrivateKey" = var.argocd_credentials_key
    "type"          = "git"
    "url"           = var.argocd_credentials_url
    "name"          = var.argocd_credentials_name
    "project"       = "default"
  }
}

### ROOTAPP ###

resource "helm_release" "rootapp" {
  depends_on = [
    helm_release.argocd,
    kubernetes_secret.argocd_repo_credentials
  ]

  namespace  = var.argocd_namespace
  name       = var.rootapp_name
  repository = var.rootapp_repository
  chart      = var.rootapp_chart
  version    = var.rootapp_version
  values = [
    templatefile("${path.module}/templates/rootapp-values.tpl",
    {
      argocd_namespace = var.argocd_namespace
      argocd_credentials_url = var.argocd_credentials_url
      rootapp_repo_revision = var.rootapp_repo_revision
      rootapp_repo_path = var.rootapp_repo_path
    })
  ]
}
