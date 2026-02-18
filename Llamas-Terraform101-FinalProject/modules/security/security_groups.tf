# 1. Bastion SG (Already good, stays the same)
resource "aws_security_group" "bastion_sg" {
  name   = "${var.lastname}-${var.project_name}-BastionSG"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all for your remote SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lastname}-${var.project_name}-BastionSG" }
}

# 2. ALB SG (Already good, stays the same)
resource "aws_security_group" "alb_sg" {
  name   = "${var.lastname}-${var.project_name}-ALBSG"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lastname}-${var.project_name}-ALBSG" }
}

# 3. Frontend SG (NEW - Replaces part of private_sg)
resource "aws_security_group" "frontend_sg" {
  name   = "${var.lastname}-${var.project_name}-FrontendSG"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Only ALB can reach web servers
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Requirement #6
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lastname}-${var.project_name}-FrontendSG" }
}

# 4. Backend SG (NEW - Replaces the rest of private_sg)
resource "aws_security_group" "backend_sg" {
  name   = "${var.lastname}-${var.project_name}-BackendSG"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # NLB communicates internally
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Requirement #6
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.lastname}-${var.project_name}-BackendSG" }
}