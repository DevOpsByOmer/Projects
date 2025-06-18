variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

# VPC
variable "vpc_name" {
  type = string
}
variable "vpc_cidr_block" {
  type = string
}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "azs" {
  type = list(string)
}

# ECR
variable "ecr_repo_names" {
  description = "List of ECR repositories to create"
  type        = list(string)
}

# ECS

variable "frontend_image" {}

variable "backend_image" {}



# Load Balancer
variable "lb_name" {
  type = string
}

variable "db_password" {
  type = string
}
