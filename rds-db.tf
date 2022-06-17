# create RDS-MSQL

resource "aws_db_instance" "demordss3db" {
identifier = "demordss3db"
storage_type = "gp2"
allocated_storage = 20
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
name = "rdss3db01"
username = "rdsdb01admin"
password = "rdsadmin01$12345"
parameter_group_name = "default.mysql8.0"
publicly_accessible = true
skip_final_snapshot  = true
db_subnet_group_name = aws_db_subnet_group.rds-db-subnet-group.id
availability_zone  = "eu-west-2a"
deletion_protection = true
vpc_security_group_ids = [aws_security_group.demo-rds-sg02.id, aws_security_group.demo-rds-sg01.id]

tags = {
  Name = "demordsDB01"
  }
}
