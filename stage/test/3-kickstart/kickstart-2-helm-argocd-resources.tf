resource "helm_release" "argo_cd_resources" {
    name    = "argo-cd-resources"
    chart   = "../../../helm/charts/argo-cd-resources"
    namespace = "argocd"
    create_namespace = false
    values = [
        yamlencode({
            clientId  = var.client_id
            clientSecret = var.client_secret
            githubToken = var.github_token
        }),
        
    ]

    depends_on = [ 
        helm_release.argo_cd
    ]

#  force_update = true
}