provider "aws" {
    region = "ap-south-1"
    access_key = "AKIAZ3OZYLMB3VYYP7MS"
    secret_key = "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"
}
resource "aws_vpc" "stage-vpc" {
     cidr_block = var.vpc_cidr_block
     tags = {
        Name : "${var.environment}-vpc"
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
module "my-subnet" {
   source = "/modules/subnet"
   vpc_id = aws_vpc.stage_vpc.id
   subnet_cidr_block = var.subnet_cidr_block
   availability_zone = var.availability_zone
   environment = var.environment
}

module "webserver" {
    source = "/modules/webserver"
    vpc_id = var.vpc_id
    my_ip  = var.my_ip
    availability_zone = var.availability_zone
    environment = var.environment
    instance_type = var.instance_type
    subnet_id = modules.webserver.subnet.id
    public_key_location = var.public_key_location
    private_key_location = var.private_key_location

  
}




