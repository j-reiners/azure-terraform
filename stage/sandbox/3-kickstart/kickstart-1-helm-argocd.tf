resource "helm_release" "argo_cd" {
    name    = "argo-cd"
    repository = "https://argoproj.github.io/argo-helm"
    chart   = "argo-cd"
    version = "6.7.12"
    namespace = "argocd"
    create_namespace = true
    dependency_update = true
    values = [
        file("${path.module}/../../../helm/values/argo-cd.yaml"),
        
    ]

    # force_update = true
}