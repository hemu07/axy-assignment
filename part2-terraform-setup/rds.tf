resource "aws_db_subnet_group" "this" {
  subnet_ids = [
    aws_subnet.privateSubnetA.id,
    aws_subnet.privateSubnetB.id
  ]
}

resource "aws_db_instance" "postgres" {
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  multi_az             = true
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  username = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["username"]
  password = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["password"]
  db_name  = jsondecode(aws_secretsmanager_secret_version.db.secret_string)["dbname"]

  backup_retention_period = 7
}

