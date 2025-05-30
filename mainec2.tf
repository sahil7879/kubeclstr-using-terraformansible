provider "aws" {
  region = var.region
}

# Fetch the latest Ubuntu AMI in the given region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Owner ID for Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*64-generic"]
  }
}

# Fetch the default VPC in the region
data "aws_vpc" "default" {
  default = true
}

# Fetch the default public subnet in the default VPC
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id
}

# Master Instance
resource "aws_instance" "master" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.medium"
  key_name        = var.key_name
  subnet_id       = data.aws_subnet_ids.public.ids[0]
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
  subnet_id       = data.aws_subnet_ids.public.ids[0]
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
  subnet_id       = data.aws_subnet_ids.public.ids[0]
  tags = {
    Name = "w2"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}
