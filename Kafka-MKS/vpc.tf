# Create VPC using Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  # Details
  name            = "${var.name}${local.name}"
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # DNS Parameters in VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Additional tags for the VPC
  tags     = local.tags
  vpc_tags = local.tags

  #NAT Gateways -	Outbound Communication
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway


  # Additional tags for the public subnets
  public_subnet_tags = {
    Name                     = "VPC Public Subnets"
    "kubernetes.io/role/elb" = 1
  }


  # Additional tags for the private subnets
  private_subnet_tags = {
    Name                              = "VPC Private Subnets"
    "kubernetes.io/role/internal-elb" = 1
  }

}
