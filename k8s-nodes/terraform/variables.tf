variable "project_name" {
  default = "k8s-cluster"
}

variable "vpc_id" {
  description = "Existing VPC ID"
}

variable "subnet_id" {
  description = "Private subnet ID"
}

variable "instance_type" {
  default = "c7i-flex.large"
}
