variable "name" {
  type = string
}

variable "value" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "secure" {
  type    = bool
  default = true
}
