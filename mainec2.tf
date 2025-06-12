provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# Fetch the default VPC in the region
data "aws_vpc" "default" {
  default = true
}

# Fetch the default public subnets in the default VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Master Instance
resource "aws_instance" "master" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.medium"
  key_name        = var.key_name
  subnet_id       = data.aws_subnets.public.ids[0]
  tags = {
    Name = "master"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}

# Worker Instance 1
resource "aws_instance" "worker1" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  key_name        = var.key_name
  subnet_id       = data.aws_subnets.public.ids[0]
  tags = {
    Name = "w1"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}

# Worker Instance 2
resource "aws_instance" "worker2" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.micro"
  key_name        = var.key_name
  subnet_id       = data.aws_subnets.public.ids[0]
  tags = {
    Name = "w2"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}
