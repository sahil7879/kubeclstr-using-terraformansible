variable "elb-names" {
  type = list
  default = ["kuber-master", "kuber-w1","Kuber-w2"]
}

variable "list" {
  type = list
  default = ["t2.medium","t2.medium","t2.medium"]
}


provider "aws" {
  region     = "ap-south-1"
#  version = "5.60.0"
# access_key = "PUT-YOUR-ACCESS-KEY-HERE"
# secret_key = "PUT-YOUR-SECRET-KEY-HERE"
}

resource "aws_instance" "kube" {
ami = "ami-0dee22c13ea7a9a67"
count= 3

# SSH key pair
  key_name = "awskp"

   instance_type = var.list[count.index]
tags= {
Name= var.elb-names[count.index]
}
# Block device mapping for the EBS volume
  root_block_device {
    volume_size = 20  # Size in GB
    volume_type = "gp2"  # General Purpose SSD
  }
}
output "instances_ip" {
  value = aws_instance.kube[*].public_ip
}
