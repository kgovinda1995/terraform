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