provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAZ3OZYLMB3VYYP7MS"
    secret_key = "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"
}

variable "availability_zone" {
    description = "availability_zone"
  }

variable "environment" {
    description = "environment"
  }  
variable "vpc_cidr_block" {
    description = "vpc cidr block"
  }

variable "subnet_cidr_block" {
    description = "subnet cidr block"
  }  

resource "aws_vpc" "dev-vpc" {
     cidr_block = var.vpc_cidr_block
     tags = {
        Name : "dev-vpc"
        Env: var.environment
    }
}

resource "aws_subnet" "sub-dev-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name : "dev-sub-1"
        Env: var.environment
    }
}
data "aws_vpc" "existing-vpc" {
   default = true
}

output "aws-vpc-id" {
    value = aws_vpc.dev-vpc.id
}

output "aws-subnet-id" {
    value = aws_subnet.sub-dev-1.id
}

output "aws-default-vpc-id" {
    value = data.aws_vpc.existing-vpc.id
}

