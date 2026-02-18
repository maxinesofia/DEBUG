output "alb_dns" {
  value = aws_lb.frontend.dns_name
}

output "ami_id" {
  value = data.aws_ami.amazon_linux_2023.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}