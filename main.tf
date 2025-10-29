provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAZ3OZYLMB3VYYP7MS"
    secret_key = "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"
}

variable availability_zone {}

variable environment {}  

variable vpc_cidr_block {}

variable "subnet_cidr_block" {
  type = list(string)
}

variable my_ip {}

variable instance_type {}

variable public_key_location {}
variable private_key_location {}


resource "aws_vpc" "stage-vpc" {
     cidr_block = var.vpc_cidr_block
     tags = {
        Name : "${var.environment}-vpc"
        Env: var.environment
    }
}

resource "aws_subnet" "sub-stage-1" {
    vpc_id = aws_vpc.stage-vpc.id
    cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name : "${var.environment}-sub-1"
        Env: var.environment
    }
}

resource "aws_subnet" "sub-stage-2" {
    vpc_id = aws_vpc.stage-vpc.id
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true
    tags = {
        Name : "${var.environment}-sub-2"
        Env: var.environment
    }
}

resource "aws_internet_gateway" "stage-igw" {

    vpc_id = aws_vpc.stage-vpc.id

    tags = {
        Name : "${var.environment}-igw"
        Env: var.environment
    }
}

/*resource "aws_default_route_table" "default-stage-rtb" {
    default_route_table_id = aws_vpc.stage-vpc.default_route_table_id

      route {
       cidr_block = "0.0.0.0/0"

       gateway_id = aws_internet_gateway.stage-igw.id
      }
  
}*/
resource "aws_route_table" "stage-rtb" {
      vpc_id = aws_vpc.stage-vpc.id

      route {
       cidr_block = "0.0.0.0/0"

       gateway_id = aws_internet_gateway.stage-igw.id
      }
  
}

resource "aws_route_table_association" "a-rtb-subnet-1" {
         subnet_id = aws_subnet.sub-stage-1.id
         route_table_id = aws_route_table.stage-rtb.id
}
resource "aws_route_table_association" "a-rtb-subnet-2" {
         subnet_id = aws_subnet.sub-stage-2.id
         route_table_id = aws_route_table.stage-rtb.id
}

resource "aws_security_group" "stage-sg" {
    name = "stage-sg"
    vpc_id = aws_vpc.stage-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ var.my_ip]
    }
   
    ingress {
        from_port = 1
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
   egress {
        from_port = 1
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

     tags = {
        Name : "${var.environment}-sg"
        Env: var.environment
    }
  
}

data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
        name = "name"
        values = [ "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-*-20250821" ]
    }
    filter {
        name = "root-device-type"
        values = [ "ebs" ]
    }
    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }

      filter {
        name = "architecture"
        values = [ "x86_64" ]
    }

}
resource "aws_key_pair" "my-terraform-1" {
   key_name = "my-terraform-1"
   public_key = file(var.public_key_location)
  
}
resource "aws_instance" "stage-server" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = var.instance_type

    subnet_id = aws_subnet.sub-stage-1.id
    vpc_security_group_ids = [ aws_security_group.stage-sg.id ]
    key_name = "my-terraform-1"
    availability_zone = var.availability_zone
    associate_public_ip_address = true

  # user_data = file("entry-script.sh") 

  connection {
     type = "ssh"
     host = self.public_ip
     user = "ubuntu"
     private_key = file(var.private_key_location)
  }
provisioner "remote-exec" {
  
  inline = [ 
       "echo my name is govinda >> info.txt",
       "docker info"

   ]
}

     tags = {
        Name : "${var.environment}-server"
        Env: var.environment
    }
  
}

data "aws_vpc" "existing-vpc" {
   default = true
}

output "aws-vpc-id" {
    value = aws_vpc.stage-vpc.id
}

output "aws-subnet-id-1" {
    value = aws_subnet.sub-stage-1.id
}

output "aws-subnet-id-2" {
    value = aws_subnet.sub-stage-2.id   
}

output "aws-default-vpc-id" {
    value = data.aws_vpc.existing-vpc.id
}

output "aws-igw-id" {
    value = aws_internet_gateway.stage-igw.id
}

output "aws-rtb-id" {
    value = aws_route_table.stage-rtb.id
}

output "aws-ami-id" {
    value = data.aws_ami.latest-ubuntu-image.id
}

output "aws-instance-id" {
    value = aws_instance.stage-server.id
}

output "aws-ec2-public-ip" {
    value = aws_instance.stage-server.public_ip
}