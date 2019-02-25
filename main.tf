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