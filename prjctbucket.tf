#create s3 bucket for project01

resource "aws_s3_bucket" "project01-data-bucket" {

   bucket = "project01-data-bucket"

  }

resource "aws_s3_bucket_acl" "project01-bucket-acl" {

    bucket = aws_s3_bucket.project01-data-bucket.id

    acl    = "private"
}

resource "aws_s3_bucket_versioning" "project01-bucket-versioning" {

  bucket = aws_s3_bucket.project01-data-bucket.id

  versioning_configuration {

    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project01-bucket-encyption" {

  bucket = aws_s3_bucket.project01-data-bucket.bucket

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "AES256"
    }
  }
}
