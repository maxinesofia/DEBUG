variable "vpc_id"          { type = string }
variable "public_subnets"  { type = list(string) }
variable "private_subnets" { type = list(string) }

variable "frontend_sg_id"  { type = string }
variable "backend_sg_id"   { type = string }
variable "bastion_sg_id"   { type = string }
variable "alb_sg_id"       { type = string } 

variable "lastname"        { type = string }
variable "project_name"    { type = string } 
variable "key_name" { type = string }