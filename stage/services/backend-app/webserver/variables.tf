variable "aws_region" {
  type = string
  description = "AWS region"
}
variable "aws_availability_zone" {
  type = string
  description = "AWS Availability Zone"
}

variable "ami_type" {
  type = string
  description = "AMI Type"
}

variable "ami_type_ubuntu" {
  type = string
  description = "AMI Type ubuntu"
}

variable "server_port" {
  type = number
  description = "Port for connecting to webserver"
  default     = 8080
}

variable "ssh_port" {
  type = number
  description = "Port for connecting to ssh"
  default     = 22
}

variable "key_pair" {
  description = "Key Pair for SSH"
  type        = string
  default = "bidd-local"
}