resource "aws_ssm_parameter" "this" {
  name        = var.name
  type        = var.secure ? "SecureString" : "String"
  value       = var.value
  description = var.description
  overwrite   = true
}
