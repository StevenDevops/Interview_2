variable "region" {
  default     = "ap-northeast-1"
  description = "AWS region"
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "flask-eks-demo"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = "education-vpc"
  cidr                 = "10.2.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  public_subnets       = ["10.2.4.0/24", "10.2.5.0/24", "10.2.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
