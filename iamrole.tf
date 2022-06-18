#create iam_role for aws glue-RDS-S3

resource "aws_iam_role" "s3-crawler-role01" {
  name               = "s3-crawler-role01"
  assume_role_policy = data.aws_iam_policy_document.glue-assume-role-policy01.json
}

#create glue_policy

data "aws_iam_policy_document" "glue-assume-role-policy01" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AWSGlueServiceRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"

}

resource "aws_iam_role_policy_attachment" "glue-service-role-attachment01" {
  role       = aws_iam_role.s3-crawler-role01.name
  policy_arn = data.aws_iam_policy.AWSGlueServiceRole.arn
}


#for s3 access

data "aws_iam_policy_document" "s3-assume-role-policy01" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3-service-role-attachment01" {
  role       = aws_iam_role.s3-crawler-role01.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}


