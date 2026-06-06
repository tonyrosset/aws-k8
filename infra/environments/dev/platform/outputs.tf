output "aws_load_balancer_controller_service_account" {
  value = kubernetes_service_account.aws_load_balancer_controller.metadata[0].name
}