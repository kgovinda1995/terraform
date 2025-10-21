provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAZ3OZYLMB3VYYP7MS"
    secret_key = "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"
}

resource "aws_vpc" "dev-vpc" {
     cidr_block = "172.31.0.0/16"

     tags = {
        Name : "dev-vpc"
        env: "dev"
    }
}

resource "aws_subnet" "sub-dev-1" {
    vpc_id = aws_vpc.dev-vpc.id
    cidr_block = "172.31.1.0/24"
    availability_zone = "ap-south-1a" 
    map_public_ip_on_launch = true
    tags = {
        Name : "dev-sub-1"
        Env: "dev"
    }
}

