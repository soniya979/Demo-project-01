#create connection #1 RDS-glue

resource "aws_glue_connection" "rds-glue-connection01" {
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:mysql://demordss3db.cbew7knnwrbv.eu-west-2.rds.amazonaws.com:3306/rdsdb01"
    USERNAME            = "rdsdb01admin"
    PASSWORD            = "rdsadmin01$12345"
  }

  name = "rds-glue-connection01"

  physical_connection_requirements {
    availability_zone      = "eu-west-2a"
    security_group_id_list = [aws_security_group.demo-rds-sg02.id, aws_security_group.demo-rds-sg01.id]
    subnet_id              = aws_subnet.rds-db-pub-subnet01.id
  }
}


#create rds_glue_calalog_database

resource "aws_glue_catalog_database" "rdss3-rawdata-catalog01" {
  name = "rdss3-rawdata-catalog01"
}

#create glue_crawler RDS

resource "aws_glue_crawler" "rds-s3-glue-crawler01" {
  database_name = aws_glue_catalog_database.rdss3-rawdata-catalog01.name
  name          = "rds-s3-glue-crawler01"
  schedule      = "cron(/2 * * * ? *)"
  role          =  aws_iam_role.s3-crawler-role01.arn
 #table_prefix =  "raw_data_catalog_tb"

  jdbc_target {
    connection_name = aws_glue_connection.rds-glue-connection01.name
    path            = "rdsdb01/%"
 }
}


# ====================================

#2- s3 connection

resource "aws_glue_connection" "s3-glue-connection01" {
  connection_type = "NETWORK"

  name = "s3-glue-connection01"

  physical_connection_requirements {
    availability_zone      = "eu-west-2a"
    security_group_id_list = [aws_security_group.demo-rds-sg02.id, aws_security_group.demo-rds-sg01.id]
    subnet_id              = aws_subnet.rds-db-pub-subnet01.id
  }
}

#create s3_glue_calalog_database

resource "aws_glue_catalog_database" "s3-rawdata-catalog01" {
  name = "s3-rawdata-catalog01"
 
}

#create glue_crawler S3

resource "aws_glue_crawler" "s3-raw-glue-crawler01" {
  database_name = aws_glue_catalog_database.s3-rawdata-catalog01.name
  name          = "s3-raw-glue-crawler01"
  schedule      = "cron(/2 * * * ? *)"
  role          =  aws_iam_role.s3-crawler-role01.arn
 #table_prefix =  "raw_data_catalog_tb"

   s3_target {
    path = "s3://project01-data-bucket/rds-raw-data/"
    connection_name = aws_glue_connection.s3-glue-connection01.name
  }
}

#create rds-s3-rawdata-job

resource "aws_glue_job" "rds-s3-raw-data-glue-job" {
  name     = "rds-s3-raw-data-glue-job"
  connections = [aws_glue_connection.rds-glue-connection01.id, aws_glue_connection.s3-glue-connection01.id]
  role_arn = aws_iam_role.s3-crawler-role01.arn

  command {
#     script_location = "s3://${aws_s3_bucket.example.bucket}/example.py"
    script_location = "s3://project01-data-bucket/scripts/rdss3data.py"
  }
}

# create job schedule

resource "aws_glue_trigger" "rds-s3-raw-data-job-schedule" {
  name     = "rds-s3-raw-data-job-schedule"
#   schedule = "cron(/2 * * * ? *)"
#   type     = "SCHEDULED"
    type = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.rds-s3-raw-data-glue-job.name
  }
}

#to import job

resource "aws_glue_job" "my_job_resource" {
    name     = "my-glue-job"
    role_arn = aws_iam_role.s3-crawler-role01.arn
    command {
        name            = "glueetl"
        script_location = "s3://project01-data-bucket/scripts/testjob.py"
        
    }
}
