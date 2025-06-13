variable "ecr_repo_names" {
  description = "Name of the ECR repository"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
