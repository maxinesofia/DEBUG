resource "aws_lb" "backend" {
  name = "${var.lastname}-${var.project_name}-NLB"
  internal           = true 
  load_balancer_type = "network"
  subnets            = var.private_subnets
}

resource "aws_lb_target_group" "backend_tg" {
  name = "${var.lastname}-${var.project_name}-BackTG"
  port     = 80
  protocol = "TCP" 
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTP"
    port                = "80"
    path                = "/"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }
}