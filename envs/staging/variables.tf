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
