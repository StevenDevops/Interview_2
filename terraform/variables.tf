##################################################################################
# VARIABLES
##################################################################################

variable "AWS_SECRET_PRIVATE_KEY" {}
variable "key_name" {}

variable "environment" {}

variable "aws_region" {
  default = "ap-northeast-1"
}

variable "aws_profile" {
  default = "aws-steven"
}

variable network_address_space {
  type = map(string)
}

variable "instance_size" {
  type = map(string)
}

variable "subnet_count" {
  type = map(number)
}
variable "instance_count" {
  type = map(number)
}

variable "billing_code_tag" {}
variable "bucket_name_prefix" {}


##################################################################################
# LOCALS
##################################################################################

locals {
  env_name = var.environment

  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = local.env_name
  }

  s3_bucket_name = "${var.bucket_name_prefix}-${local.env_name}-${random_integer.rand.result}"

}
