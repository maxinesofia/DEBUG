resource "aws_instance" "bastion" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = var.public_subnets[0]
  
  vpc_security_group_ids = [var.bastion_sg_id]
  associate_public_ip_address = true

tags = { 
    Name = "${var.lastname}-${var.project_name}-Bastion" 
  }
}