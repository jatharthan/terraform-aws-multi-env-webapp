# Web Tier
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
# Launch Template for Web Tier
resource "aws_launch_template" "web_launch_template" {
  name_prefix   = "${var.project_prefix}-${var.region}-${var.environment}-web-lt-"
  image_id      = var.ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.aws_iam_instance_profile
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.public_web_sg_id]
  }

  user_data = base64encode(templatefile("${path.module}/scripts/web-userdata.sh", {
    project_prefix = var.project_prefix
    git_sha        = var.git_sha
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_prefix}-${var.region}-${var.environment}-web-instance"
      GitSHA = var.git_sha
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_prefix}-${var.region}-${var.environment}-web-launch-template"
    GitSHA   = var.git_sha  # ✅ Add this tag purely to force diff when SHA changes
  }
}

# Target Group for External Load Balancer
resource "aws_lb_target_group" "web_target_group" {
  name     = "${var.project_prefix}-${var.region}-${var.environment}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 3
    healthy_threshold   = 3
    port                = 3000
  }

  tags = {
    Name = "${var.project_prefix}-${var.region}-${var.environment}-web-target-group"
  }
}

# External Load Balancer
resource "aws_lb" "external_web_lb" {
  name                        = "${var.project_prefix}-${var.region}-${var.environment}-web-lb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [var.public_lb_sg_id]
  subnets                     = var.public_web_subnet_ids
  enable_deletion_protection  = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.project_prefix}-${var.region}-${var.environment}-external-web-lb"
  }
}

resource "aws_lb_listener" "external_web_listener" {
  load_balancer_arn = aws_lb.external_web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }

  tags = {
    Name = "${var.project_prefix}-${var.region}-${var.environment}-external-web-listener"
  }
}

# Auto Scaling Group for Web Tier
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity          = 2
  min_size                  = 2
  max_size                  = 4
  name                      = "${var.project_prefix}-${var.region}-${var.environment}-web-asg"
  vpc_zone_identifier       = var.public_web_subnet_ids

  launch_template {
    id      = aws_launch_template.web_launch_template.id
    # version = "$Latest"
    version = aws_launch_template.web_launch_template.latest_version
  }

  target_group_arns = [
    aws_lb_target_group.web_target_group.arn
  ]

  health_check_type           = "ELB"
  health_check_grace_period  = 300
  force_delete                = true
  wait_for_capacity_timeout   = "0"

  tag {
    key                 = "Name"
    value               = "${var.project_prefix}-${var.region}-${var.environment}-web-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "deployment-sha"
    value               = var.git_sha
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

#Rolling update with rollback ####
  instance_refresh {
    strategy = "Rolling"
    triggers = ["launch_template"]

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 120
    }
  }
}