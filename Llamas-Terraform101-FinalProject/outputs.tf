output "application_load_balancer_url" {
  description = "The DNS name of the frontend load balancer"
  value       = "http://${module.compute.alb_dns}"
}

output "ami_used" {
  description = "The Amazon Linux 2023 AMI ID dynamically selected for this region"
  value       = module.compute.ami_id
}

output "bastion_public_ip" {
  description = "The public IP of the Bastion host for SSH access"
  value       = module.compute.bastion_public_ip
}