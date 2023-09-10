provider "aws" {
        region = "ap-south-1"
        }

#To create S3 bucket
resource "aws_s3_bucket" "demo-S3" {
        bucket = "terraform-batch4-bucket"
        }

#To create dummy instance
resource "aws_instance" "demo-ec2" {
        ami = var.ec2-ubuntu-ami
        instance_type = "t2.micro"
        tags = {
                Name= "terra-auto-instance"
        }
}

#Adding other details-Key
resource "aws_key_pair" "mykey" {
        key_name = "terra-key"
        public_key = file("~/.ssh/terra-key.pub")
}

#To create instance
resource "aws_instance" "my-ivpc-instance" {
        key_name = aws_key_pair.mykey.key_name
        ami = var.ec2-ubuntu-ami
        instance_type = "t2.micro"
        security_groups = [aws_security_group.allow_ssh.name]
        tags = {
                Name = "terra-true-instance"
        }
}

#Create default VPC
resource "aws_default_vpc" "default_vpc" {}

#Security grp
resource "aws_security_group" "allow_ssh" {
        name = "allow_ssh"
        description = "Allow ssh inbound traffic"

vpc_id = aws_default_vpc.default_vpc.id
ingress {
 description = "TLS from VPC"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks=["0.0.0.0/0"]
        }
tags = {
    Name = "allow_ssh"
  }

}
