#VPC

resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames  = true
  
tags = {
    Name = "demo-vpc"
  }
}

# For internet access

resource "aws_internet_gateway" "demo-vpc-igw" {
  vpc_id = aws_vpc.demo-vpc.id

# depends_on = [
#     aws_vpc.demo-vpc
#   ]
  
    tags = {
    Name = "demo-vpc-igw"
  }
}

# ================= RDS-MySQL Subnets ============

# RDS-MySQL public subnets in different AZs

resource "aws_subnet" "rds-db-pub-subnet01" {
vpc_id = aws_vpc.demo-vpc.id
cidr_block = "10.0.0.0/24"
availability_zone = "eu-west-2a"
map_public_ip_on_launch = "true"

tags = {
    Name = "rds-db-pub-subnet01"
  }
}

resource "aws_subnet" "rds-db-pub-subnet02" {
vpc_id = aws_vpc.demo-vpc.id
cidr_block = "10.0.1.0/24"
availability_zone = "eu-west-2b"
map_public_ip_on_launch = "true"
 
tags = {
    Name = "rds-db-pub-subnet02"
  }
}

#create public route tabel

resource "aws_route_table" "rdsdb-pubrt01" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "rdsdb-pubrt01"
  }
}

# Associate public subnets to public route tabel

resource "aws_route_table_association" "rdsdb-pubrtasso01" {
  subnet_id      = aws_subnet.rds-db-pub-subnet01.id
  route_table_id = aws_route_table.rdsdb-pubrt01.id
}

resource "aws_route_table_association" "rdsdb-pubrtasso02" {
  subnet_id      = aws_subnet.rds-db-pub-subnet02.id
  route_table_id = aws_route_table.rdsdb-pubrt01.id
}

#  route for interney gateway

resource "aws_route" "rdsdb-publicsnroute01" {
  route_table_id = aws_route_table.rdsdb-pubrt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.demo-vpc-igw.id
}

# add vpc s3 endpoint 

resource "aws_vpc_endpoint" "rdsglues3ep" {
  vpc_id            = aws_vpc.demo-vpc.id
  service_name      = "com.amazonaws.eu-west-2.s3"

#   security_group_ids = [aws_security_group.demo-rds-sg01.id, aws_security_group.demo-rds-sg02.id]  # when type= interface
  
  tags = {
    Name = "rdsglues3ep"
  }
  
}

resource "aws_vpc_endpoint_route_table_association" "rds-rt-vpcs3ep" {
  route_table_id  = aws_route_table.rdsdb-pubrt01.id
  vpc_endpoint_id = aws_vpc_endpoint.rdsglues3ep.id
}

# resource "aws_vpc_endpoint_subnet_association" "sn-rds" {
#   vpc_endpoint_id = aws_vpc_endpoint.rdsglues3.id
#   subnet_id       = [aws_subnet.rdsdb-pubrtasso01.id, aws_subnet.rdsdb-pubrtasso02.id]
# }

# RDS-DB subnets group

resource "aws_db_subnet_group" "rds-db-subnet-group" {
name = "rds-db-subnet-group"
subnet_ids = [aws_subnet.rds-db-pub-subnet01.id, aws_subnet.rds-db-pub-subnet02.id]

tags = {
    Name = "rds-db-subnet-group"
  }
 }


#   =========== Redshift cluster ==================================

#create redshift cluster subnets in different AZs

resource "aws_subnet" "redshift-pub-subnet01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "redshift-pub-subnet01"
  }

# depends_on = [
#     aws_vpc.demo-vpc
#   ]
}

resource "aws_subnet" "redshift-pub-subnet02" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2b"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "redshift-pub-subnet02"
  }

# depends_on = [
#     aws_vpc.demo-vpc
#   ]
}

# Redshift Cluster subnet group

resource "aws_redshift_subnet_group" "redshift-subnet-group" {
  name       = "redshift-subnet-group"
  subnet_ids = [aws_subnet.redshift-pub-subnet01.id, aws_subnet.redshift-pub-subnet02.id]

tags = {
  
    Name = "redshift-subnet-group"
  }
}
# ============== EMR -Cluster Subnet ====================================

# EMR-Cluster Public subnet

resource "aws_subnet" "emr-pub-subnet01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "emr-pub-subnet01"
  }
}

#create public route tabel

resource "aws_route_table" "emr-pubrt01" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "emr-pubrt01"
  }
}

# Associate public subnets to public route tabel

resource "aws_route_table_association" "emr-pubrtasso01" {
  subnet_id      = aws_subnet.emr-pub-subnet01.id
  route_table_id = aws_route_table.emr-pubrt01.id
}


#  route for interney gateway

resource "aws_route" "emr-publicsnroute01" {
  route_table_id = aws_route_table.emr-pubrt01.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id  = aws_internet_gateway.demo-vpc-igw.id
}

