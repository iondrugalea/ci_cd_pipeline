#Create VPC
resource "aws_vpc" "main"{
 cidr_block = "${var.VPC_CIDR_BLOCK}"
 enable_dns_support = "true"
 enable_dns_hostnames = "true"
 tags ={
  Name = "${var.PROJECT_NAME}"
}
}
#Create Public Subnet
data "aws_availability_zones" "available" {}
resource "aws_subnet" "pub_subnet"{
vpc_id = "${aws_vpc.main.id}"
cidr_block = "${var.VPC_CIDR_BLOCK}"
availability_zone = "${data.aws_availability_zones.available.names[0]}"
tags = {
    Name = "${var.PROJECT_NAME}-pub-subnet"
  }

}
#Create AWS Internet gateway
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "My VPC - Internet Gateway"
  }
}
#Create AWS Route Table
resource "aws_route_table" "art"{
vpc_id = "${aws_vpc.main.id}"
route {
cidr_block = "0.0.0.0/0"
geteway_id = "${aws_internet_gateway.jenkins_igw.id}"
 }
 tags {
  Name = "Public subnet route table"
}

}
 
#Atach the route table to Subnet

#Create AWS Security Group
resource "aws_security_group" "allow_ssh" {
name = "Allow traffiq for Jenkins Server"
description = "Security group for Jenkins Cluster"
vpc_id = "${aws_vpc.main.id}"

egress{
from_port       = 0
to_port         = 0
cidr_blocks     = "${var.OUTBOUND_CIDR_BLOCK}"
protocol        = "-1"
}


ingress {
from_port = 443
to_port = 443
cidr_blocks = "${var.ING_CIDR_BLOCK}"
protocol = "tcp"
}
ingress {
from_port = 22
to_port = 22
cidr_blocks = "${var.ING_CIDR_BLOCK}"
protocol = "tcp"
}
}


resource "aws_route_table_association" "public_route"{
subnet_id = "${aws_subnet.pub_subnet.id}"
route_table_id = "${aws_route_table.art.id}"

}


resource "aws_instance" "jenkins-master" {
ami = "${data.aws_ami.jenkins-master.id}"
instance_type = "t2.micro"
key_name  = "${var.key_name}"
subnet_id = "${aws_subnet.pub_subnet.id}"
vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
associate_public_ip_address = true

root_block_device{
volume_type = "gp2"
volume_size = "30"
delete_on_termination = false

}
tags{
Name = "Jenkins-Master"
Author = "Ion Drugalea"
Tool = "Terraform"
}

}

