# Name of the key pair in AWS, MUST be in same region as EC2 instance
# Check README for AWS CLI commands to create a key pair
key_name = "steven"

# Local path to pem file for key pair.


# Prefix value to be used for S3 bucket. You can leave this value as-is
bucket_name_prefix = "soshub"

# Environment tag for all resources being created. You can leave this value as-is.
environment_tag = "dev"

# Made up billing code to be added as a tag to resources. You can leave this value as-is.
billing_code_tag = "SOSHUB2021"

network_address_space = {
  Development = "10.0.0.0/16"
  Production = "10.2.0.0/16"
}

instance_size = {
  Development = "t2.micro"
  Production = "t2.micro"
}

subnet_count = {
  Development = 1
  Production = 2
}

instance_count = {
  Development = 1
  Production = 2
}
