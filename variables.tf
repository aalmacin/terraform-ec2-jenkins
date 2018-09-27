variable "ubuntu_ami" {
  description = "AMI for ubuntu version"
  default = "ami-0427e8367e3770df1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of the key to set in KMS"
}

variable "availability_zone" {
  default = "ca-central-1a"
}

variable "name" {}

variable "domain" {
  description = "Domain name of the hosted zone"
}

variable "cname" {}

variable "vpc_id" {}

