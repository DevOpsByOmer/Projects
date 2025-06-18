variable "execution_role_name" {
  description = "Name for the ECS execution role"
  type        = string
  default     = "ecs-execution-role"
}

variable "task_role_name" {
  description = "Name for the ECS task role"
  type        = string
  default     = "ecs-task-role"
}
variable "region" {
  default = "ap-south-1"

}