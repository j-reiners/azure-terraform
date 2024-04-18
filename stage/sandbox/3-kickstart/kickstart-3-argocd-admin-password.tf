data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name = "argocd-initial-admin-secret"
    namespace = "argocd"
  }

  depends_on = [ 
    helm_release.argo_cd_resources
  ]
}

resource "local_file" "argocd_admin_password" {
  filename     = "/home/jan/argocd_password"
  content      = data.kubernetes_secret.argocd_admin_password.data["password"]

  depends_on   = [
    data.kubernetes_secret.argocd_admin_password
  ]
}