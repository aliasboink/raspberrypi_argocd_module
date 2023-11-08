variable "argocd_namespace" {
  type        = string
  default     = "argocd"
}

variable "argocd_name" {
  type        = string
  default     = "argocd"
}

variable "argocd_repository" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "argocd_chart" {
  type        = string
  default     = "argo-cd"
}

variable "argocd_version" {
  type        = string
  default     = "5.51.0"
}

variable "argocd_force_update" {
  type        = bool
  default     = false
}

### REPO CREDENTIALS ###

variable "argocd_credentials_key" {
  description = "SSH key for the rootapp repository. It has to be supplied as an environmetn variable."
  type = string
}

variable "argocd_credentials_git" {
  type = string
  default = "git"
}

variable "argocd_credentials_url" {
  type = string
  default = "git@github.com:aliasboink/raspberrypi_argocd_charts.git"
}

variable "argocd_credentials_name" {
  type = string
  default = "rootapp-repo"
}

### ROOTAPP ###

variable "rootapp_enabled" {
  type        = bool
  default     = false
}

variable "rootapp_name" {
  type        = string
  default     = "rootapp"
}

variable "rootapp_repository" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
}

variable "rootapp_chart" {
  type        = string
  default     = "argocd-apps"
}

variable "rootapp_version" {
  type        = string
  default     = "1.0.0"
}

variable "rootapp_repo_revision" {
  type = string
  default = "HEAD"
}

variable "rootapp_repo_path" {
  type = string
  default = "./"
}