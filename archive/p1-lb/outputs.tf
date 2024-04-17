output "loadbalancer1_link" {
  value = "http://${azurerm_public_ip.p1_lb_loadbalancer_public_ip.ip_address}"
}