resource "local_file" "kubeconfig" {
  filename     = "/home/jan/kubeconfig"
  content      = azurerm_kubernetes_cluster.aks1.kube_config_raw

  depends_on   = [
    azurerm_kubernetes_cluster.aks1
  ]
}