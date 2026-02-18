resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.lastname}-${var.project_name}-frontend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = var.key_name
  
  vpc_security_group_ids = [var.frontend_sg_id]

  user_data = base64encode(templatefile("${path.root}/scripts/frontend_userdata.sh", {
    nlb_address = aws_lb.backend.dns_name
  }))

  monitoring { enabled = true }

  tag_specifications {
    resource_type = "instance"
    tags = merge(data.aws_default_tags.current.tags, { 
      Name = "${var.lastname}-${var.project_name}-FrontendHost" 
    })
  }
}

resource "aws_autoscaling_group" "frontend" {
  name                = "${var.lastname}-${var.project_name}-FrontendASG"
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [aws_lb_target_group.frontend_tg.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300
  
  
  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.lastname}-${var.project_name}-FrontendHost"
    propagate_at_launch = true
  }
}