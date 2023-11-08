applications:
  - name: rootapp
    namespace: ${argocd_namespace}
    additionalLabels: {}
    additionalAnnotations: {}
    finalizers:
      - resources-finalizer.argocd.argoproj.io
    project: "default"
    source:
      repoURL: ${argocd_credentials_url}
      targetRevision: ${rootapp_repo_revision}
      path: ${rootapp_repo_path}
    destination:
      server: "https://kubernetes.default.svc"
      namespace: ${argocd_namespace}
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
        allowEmpty: true
      syncOptions:
        - Validate=true
        - CreateNamespace=true
        - PrunePropagationPolicy=foreground
        - PruneLast=true