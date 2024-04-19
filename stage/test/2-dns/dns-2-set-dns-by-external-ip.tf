data "cloudflare_zone" "jr_k8s_de" {
  name = "jr-k8s.de"
}

resource "cloudflare_record" "k8s_wildcard" {
  zone_id = data.cloudflare_zone.jr_k8s_de.id
  name    = "*"
  value   = data.kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 180

  depends_on = [ 
    data.kubernetes_service.nginx
  ]
}

resource "cloudflare_record" "k8s_test_wildcard" {
  zone_id = data.cloudflare_zone.jr_k8s_de.id
  name    = "*.test"
  value   = data.kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 180

  depends_on = [ 
    data.kubernetes_service.nginx
  ]
}