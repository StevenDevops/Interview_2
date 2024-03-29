##################################################################################
# VARIABLES
##################################################################################

variable "AWS_SECRET_PRIVATE_KEY" {}
variable "key_name" {}

variable "environment" {}

variable "aws_region" {
  default = "ap-northeast-1"
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


##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment
  }
}
