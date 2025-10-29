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

variable image_name {}
#Dummy