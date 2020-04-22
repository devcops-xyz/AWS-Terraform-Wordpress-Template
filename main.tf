##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.region
}

##################################################################################
# DATA
##################################################################################
data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]

 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

}
# import cloudformation output
data "aws_cloudformation_export" "vpc_id" {
  name = "VpcID"
}
data "aws_cloudformation_export" "PublicSubnetA" {
  name = "PublicSubnetA"
}
data "aws_cloudformation_export" "PublicSubnetB" {
  name = "PublicSubnetB"
}
data "aws_cloudformation_export" "PublicSubnetC" {
  name = "PublicSubnetC"
}
data "aws_cloudformation_export" "PrivateSubnetA" {
  name = "PrivateSubnetA"
}
data "aws_cloudformation_export" "PrivateSubnetB" {
  name = "PrivateSubnetB"
}
data "aws_cloudformation_export" "PrivateSubnetC" {
  name = "PrivateSubnetC"
}

##################################################################################
# RESOURCES
##################################################################################

resource "aws_instance" "Bastion" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  subnet_id              = data.aws_cloudformation_export.PublicSubnetA.value
  vpc_security_group_ids = [aws_security_group.bastionsg.id]

}
