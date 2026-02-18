module "networking" {
  source       = "./modules/networking"
  lastname     = var.lastname
  project_name = var.project_name
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.networking.vpc_id
  lastname     = var.lastname
  project_name = var.project_name
}

module "compute" {
  source          = "./modules/compute"
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  frontend_sg_id  = module.security.frontend_sg_id
  backend_sg_id   = module.security.backend_sg_id
  bastion_sg_id   = module.security.bastion_sg_id
  alb_sg_id       = module.security.alb_sg_id
  lastname        = var.lastname
  project_name    = var.project_name
  key_name        = var.key_name
}