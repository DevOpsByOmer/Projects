output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}
output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}
output "frontend_target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.backend.arn
}

output "listener" {
  value = aws_lb_listener.http.arn
}