output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_web_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "public_web_sg_id" {
  description = "Security group ID for EC2"
  value       = aws_security_group.ec2_sg.id
}

output "public_lb_sg_id" {
  description = "Security group ID for Load Balancer"
  value       = aws_security_group.alb_sg.id
}
