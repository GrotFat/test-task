output "grafana_url" {
  description = "The URL to access Grafana."
  value       = "http://${aws_eip.eip.public_ip}:${var.grafana_port}/dashboards"
}