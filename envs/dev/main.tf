module "networking" {
  providers = {
    aws = aws.useast1
  }
  source         = "../../modules/networking"
  project_prefix = var.project_prefix
  region         = var.region
  vpc_cidr_block = var.vpc_cidr_block
  environment    = var.environment
}

module "ec2" {
  source                   = "../../modules/ec2"
  providers                = { aws = aws.useast1 }
  region                   = var.region
  ami                      = var.ami
  project_prefix           = var.project_prefix
  aws_iam_instance_profile = var.aws_iam_instance_profile
  vpc_id                   = module.networking.vpc_id
  public_web_subnet_ids    = module.networking.public_web_subnet_ids
  public_web_sg_id         = module.networking.public_web_sg_id
  public_lb_sg_id          = module.networking.public_lb_sg_id
  environment    = var.environment
  instance_type = var.instance_type
}

module "dynamodb" {
  source         = "../../modules/dynamodb"
  providers      = { aws = aws.useast1 }
  region         = var.region
  project_prefix = var.project_prefix
  environment    = var.environment
}