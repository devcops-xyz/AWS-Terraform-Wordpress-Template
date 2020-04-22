resource "aws_db_subnet_group" "dbsubnetgroup" {
  name = "main"
  subnet_ids = [data.aws_cloudformation_export.PrivateSubnetA.value,
                data.aws_cloudformation_export.PrivateSubnetB.value,
                data.aws_cloudformation_export.PrivateSubnetC.value]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_secretsmanager_secret" "rdsdbsesecret" {
  description = "secret for an RDS DB instance"
  name        = "rdsdbsesecret"
}

resource "aws_secretsmanager_secret_version" "rdsdbsesecret" {
  secret_id = aws_secretsmanager_secret.rdsdbsesecret.id
  secret_string = jsonencode(var.example)
}

resource "aws_db_instance" "mydb" {
  allocated_storage       = 5
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  backup_retention_period = 0
  db_subnet_group_name    = aws_db_subnet_group.dbsubnetgroup.id
  name                    = "wp"
  username                = "admin"
  password                = jsondecode(aws_secretsmanager_secret_version.rdsdbsesecret.secret_string)["key1"]
  parameter_group_name    = "default.mysql5.7"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.dbsecuritygroup.id]
}