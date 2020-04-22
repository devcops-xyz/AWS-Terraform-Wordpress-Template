#####################################################################
resource "aws_security_group" "dbsecuritygroup" {
  name        = "dbsecuritygroup"
  description = "SecGrp for database"
  vpc_id      = data.aws_cloudformation_export.vpc_id.value
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}
resource "aws_security_group_rule" "inbound_dbsecuritygroup" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.asgsecuritygroup.id

  security_group_id = aws_security_group.dbsecuritygroup.id
}
#####################################################################
resource "aws_security_group" "elbsecuritygroup" {
  name        = "elbsecuritygroup"
  description = "SecGrp for elb"
  vpc_id      = data.aws_cloudformation_export.vpc_id.value

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
#####################################################################
resource "aws_security_group" "asgsecuritygroup" {
  name        = "asgsecuritygroup"
  description = "SecGrp for asg"
  vpc_id      = data.aws_cloudformation_export.vpc_id.value
    
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "inbound_asgsecuritygroup" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = aws_security_group.elbsecuritygroup.id

  security_group_id = aws_security_group.asgsecuritygroup.id
}
#####################################################################
resource "aws_security_group" "bastionsg" {
  name        = "bastionsg"
  description = "SecGrp for bastion"
  vpc_id      = data.aws_cloudformation_export.vpc_id.value
    
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
      ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}