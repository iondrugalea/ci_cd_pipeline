#Alle globale Variablen fuer Terraform
variable "PROJECT_NAME" {
default = "Jenkins CI/CD"}
#VPC Variablen
variable "VPC_CIDR_BLOCK" {
default =  "10.0.0.0/24"
}
#Public Subnet
variable "PUB_SUBNET"{
default  = "10.0.0.0/25"
}

variable "ING_CIDR_BLOCK" {
        type = "list"
        default = [ "0.0.0.0/0" ]
}
variable "OUTBOUND_CIDR_BLOCK" {
         type = "list"
        default = [ "0.0.0.0/0" ]
}
