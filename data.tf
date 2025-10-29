data "aws_vpc" "existing-vpc" {
   default = true
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