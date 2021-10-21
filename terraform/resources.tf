##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region  = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "public_cidrsubnet" {
  count = var.subnet_count[local.env_name]

  template = "$${cidrsubnet(vpc_cidr,8,current_count)}"

  vars = {
    vpc_cidr      = var.network_address_space[local.env_name]
    current_count = count.index
  }
}

##################################################################################
# RESOURCES
##################################################################################

#Random ID
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}


# NETWORKING #
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${local.env_name}-vpc"
  version = "2.15.0"

  cidr            = var.network_address_space[local.env_name]
  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets  = data.template_file.public_cidrsubnet[*].rendered
  private_subnets = []

  tags = local.common_tags
}

# SECURITY GROUPS #
resource "aws_security_group" "elb-sg" {
  name   = "flask_elb_sg"
  vpc_id = module.vpc.vpc_id

  #Allow port 5000 from anywhere
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.env_name}-elb-sg" })

}

# flask security group
resource "aws_security_group" "flask-sg" {
  name   = "flask"
  vpc_id = module.vpc.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # TCP access from the VPC
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space[local.env_name]]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${local.env_name}-flask-sg" })

}

# LOAD BALANCER #
resource "aws_elb" "web" {
  name = "${local.env_name}-flask-elb"

  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.elb-sg.id]
  instances       = aws_instance.flask[*].id

  listener {
    instance_port     = 5000
    instance_protocol = "tcp"
    lb_port           = 5000
    lb_protocol       = "tcp"
  }

  tags = merge(local.common_tags, { Name = "${local.env_name}-elb" })

}

# INSTANCES #
resource "aws_instance" "flask" {
  count                  = var.instance_count[local.env_name]
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = var.instance_size[local.env_name]
  subnet_id              = module.vpc.public_subnets[count.index % var.subnet_count[local.env_name]]
  vpc_security_group_ids = [aws_security_group.flask-sg.id]
  key_name               = var.key_name
  tags                   = merge(local.common_tags, { Name = "${local.env_name}-flask-vnsos" })

}

resource "null_resource" "remote_exec_from_github" {
  count = var.instance_count[local.env_name]
  connection {
    type        = "ssh"
    host        = "${aws_instance.flask[count.index].public_ip}"
    user        = "ec2-user"
    private_key = var.AWS_SECRET_PRIVATE_KEY
  }

  provisioner "file" {
    source = "../../recipes"
    destination = "/home/ec2-user/"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y",
      "sudo service docker start",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo usermod -a -G docker ec2-user",
      "cd /home/ec2-user/recipes",
      "docker-compose build",
      "docker-compose up -d --force-recreate",
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}

