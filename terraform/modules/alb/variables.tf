variable "public_subnets" {
  type = list(string)
}
variable "security_group_id" {}
variable "name" {
  description = "Name prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
