variable "project_prefix" {
  description = "Project prefix to be used in naming the bucket"
  type        = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "public_web_subnet_ids" {
  description = "Public subnets for web tier"
  type        = list(string)
}

variable "public_web_sg_id" {
  description = "Security group ID for web tier"
  type        = string
}

variable "public_lb_sg_id" {
  description = "Security group for public load balancer"
  type        = string
}

variable "aws_iam_instance_profile" {
  description = "instance profile"
  type        = string
}

variable "git_sha" {
  description = "Git commit SHA for triggering LT updates"
  type        = string
}
