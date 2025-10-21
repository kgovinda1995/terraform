provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAZ3OZYLMB3VYYP7MS"
    secret_key = "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"
}

resource "aws_vpc" "my-vpc" {
     cidr_block = "10.0.0.0/16"
     tags = {
        Name : "devlopment"
        env: "dev"
        
     }
}

resource "aws_subnet" "my-sub-1" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ap-south-1a" 
    tags = {
        Name : "my-sub-1"
        Env: "dev"
    }
}
