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
    value = aws_instance.stage-server-1.id
}

output "aws-ec2-public-ip" {
    value = aws_instance.stage-server-1.public_ip
}