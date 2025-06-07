variable "project_prefix" {
  description = "Prefix for resource names"
}

variable "region" {
  description = "AWS region to deploy"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "ami" {
  description = "ami"
}

variable "instance_type" {
  description = "instance_type"
}

variable "aws_iam_instance_profile" {
  description = "instance_type"
}
