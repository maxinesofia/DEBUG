terraform {
  backend "s3" {
    bucket       = "llamas-finalproject-terraform-state"
    key          = "terraform101/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}
