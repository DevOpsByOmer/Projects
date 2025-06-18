output "frontend_service_name" {
  value = module.frontend_ecs.service_name
}
output "rds_endpoint" {
  value = module.rds.db_endpoint
}
