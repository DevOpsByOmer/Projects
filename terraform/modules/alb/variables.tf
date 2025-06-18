variable "name" {
  description = "A name prefix for ALB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where ALB will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs to deploy ALB into"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate to enable HTTPS"
  type        = string
}
