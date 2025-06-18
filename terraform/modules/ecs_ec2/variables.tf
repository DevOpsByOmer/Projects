variable "cluster_name" {}
variable "task_family" {}
variable "container_name" {}
variable "container_image" {}
variable "container_port" {}
variable "cpu" {}
variable "memory" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "desired_count" {}
variable "subnets" {
  type = list(string)
}
variable "security_group_id" {}
variable "target_group_arn" {}
variable "lb_listener" {}

# EC2-specific
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "environment_vars" {
  type    = list(map(string))
  default = []
}
variable "service_name" {

}