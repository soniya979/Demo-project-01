# RDS-MySQL Security Group

resource "aws_security_group" "demo-rds-sg01" {
    name = "demo-rds-sg01"
    vpc_id =  aws_vpc.demo-vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
  tags = {

   Name = "demo-rds-sg01"

 }
}

resource "aws_security_group" "demo-rds-sg02" {
  name        = "demo-rds-sg02"
  description = "SG for RDS MySQL server"
  vpc_id      = aws_vpc.demo-vpc.id
  
  # Keep the instance private by only allowing traffic from the web server.
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.demo-rds-sg01.id]
#     cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "demo-rds-sg02"
  }
}


# Redshift Cluster Security Group

resource "aws_security_group" "redshift-sg01" {

 vpc_id     = aws_vpc.demo-vpc.id

ingress {

   from_port   = 5439

   to_port     = 5439

   protocol    = "tcp"

   cidr_blocks = ["0.0.0.0/0"]

 }

tags = {

   Name = "redshift-sg01"

 }

# depends_on = [

#    aws_vpc.redshift_vpc

#  ]
}


# EMR-Cluster security group

resource "aws_security_group" "emr-sg01" {
  name        = "emr-sg01"
  description = "Allow inbound traffic-EMR"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.demo-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name = "emr-sg01"
  }

  depends_on = [aws_subnet.emr-pub-subnet01]

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

}
