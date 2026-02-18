resource "aws_launch_template" "backend" {
  name_prefix   = "${var.lastname}-${var.project_name}-backend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  key_name      = var.key_name
  
  vpc_security_group_ids = [var.backend_sg_id]
  user_data              = filebase64("${path.root}/scripts/backend_userdata.sh")

  monitoring { enabled = true }

  tag_specifications {
    resource_type = "instance"
    tags = merge(data.aws_default_tags.current.tags, { 
      Name = "${var.lastname}-${var.project_name}-BackendHost" 
    })
  }
}
resource "aws_autoscaling_group" "backend" {
  name                = "${var.lastname}-${var.project_name}-BackendASG"
  vpc_zone_identifier = var.private_subnets
  target_group_arns   = [aws_lb_target_group.backend_tg.arn]
  health_check_type         = "ELB" # Add this line
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
    id      = aws_launch_template.backend.id
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
    value               = "${var.lastname}-${var.project_name}-BackendHost"
    propagate_at_launch = true
  }
}