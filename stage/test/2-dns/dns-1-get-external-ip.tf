data "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"
    namespace = "app-routing-system"
  }
}

output "external_ip" {
  value     = data.kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
}