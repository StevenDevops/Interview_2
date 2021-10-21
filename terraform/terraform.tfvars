# Name of the key pair in AWS, MUST be in same region as EC2 instance
# Check README for AWS CLI commands to create a key pair
key_name = "steven"

# Local path to pem file for key pair.


# Environment tag for all resources being created. You can leave this value as-is.
environment_tag = "dev"

# Made up billing code to be added as a tag to resources. You can leave this value as-is.
billing_code_tag = "DEVOPS2021"

network_address_space = {
  dev = "10.0.0.0/16"
  prod = "10.2.0.0/16"
}

instance_size = {
  dev = "t2.micro"
  prod = "t2.micro"
}

subnet_count = {
  dev = 1
  prod = 2
}

instance_count = {
  dev = 1
  prod = 2
}
