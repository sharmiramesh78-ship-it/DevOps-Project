provider "aws" {
  region = "us-east-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "frontend" {
  name        = "frontend-security-group"
  description = "Security group for frontend EC2"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "frontend-security-group"
  }
}

# Allow SSH
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow HTTP
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instance
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.frontend.id
  ]

  tags = {
    Name = "HelloWorld"
  }
}

# EC2 Public IP
output "ec2_public_ip" {
  value = aws_instance.example.public_ip
}