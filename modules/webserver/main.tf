resource "aws_security_group" "stage-sg" {
    name = "stage-sg"
    vpc_id = var.vpc_id

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
data "aws_vpc" "existing-vpc" {
   default = true
}
data "aws_ami" "latest-ubuntu-image" {
    most_recent = true
    owners = [ "amazon" ]
    filter {
        name = "name"
        values = var.image_name
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
resource "aws_instance" "stage-server-1" {
    ami = data.aws_ami.latest-ubuntu-image.id
    instance_type = var.instance_type

    subnet_id = var.subnet_id
    vpc_security_group_ids = [ aws_security_group.stage-sg.id ]
    key_name = "my-terraform-1"
    availability_zone = var.availability_zone
    associate_public_ip_address = true

 connection {
     type = "ssh"
     host = self.public_ip
     user = "ubuntu"
     private_key = file(var.private_key_location)
  }
/*provisioner "remote-exec" {
  
  inline = [ 
       "mkdir govinda",
       "touch govinda.txt1..4"

   ]
}*/ 

# user_data = file("entry-script.sh") 

   provisioner "file" {
       source = "entry-script.sh"
       destination = "/home/ubuntu/entry-script-on-ubuntu.sh"
 }
     provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/entry-script-on-ubuntu.sh",
      "sudo bash /home/ubuntu/entry-script-on-ubuntu.sh"
    ]
  }

    provisioner "local-exec" {

        command = "echo ${self.public_ip} > text.txt"
 }

     tags = {
        Name : "${var.environment}-server-1"
        Env: var.environment
    }
  
}