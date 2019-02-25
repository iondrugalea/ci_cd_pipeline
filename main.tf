#Create VPC
resource "aws_vpc" "main"{
 cidr_block = "${var.VPC_CIDR_BLOCK}"
 enable_dns_support = "true"
 enable_dns_hostnames = "true"
 tags ={
  Name = "${var.PROJECT_NAME}"
}
}
#Createa Subnet
data "aws_availability_zones" "available" {}
resource "aws_subnet" "pub_subnet"{
vpc_id = "${aws_vpc.main.id}"
cidr_block = "${var.VPC_CIDR_BLOCK}"
availability_zone = "${data.aws_availability_zones.available.names[0]}"
tags = {
    Name = "${var.PROJECT_NAME}-pub-subnet"
  }

}

resource "aws_security_group" "allow_tls" {
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
