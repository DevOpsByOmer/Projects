variable "aws_region" {
  type = string

}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string

}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "key_name" {
  type = string
}
