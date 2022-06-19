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

#For RDSFullAccess

data "aws_iam_policy_document" "rds-assume-role-policy01" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "AmazonRDSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "rds-service-role-attachment01" {
  role       = aws_iam_role.s3-crawler-role01.name
  policy_arn = data.aws_iam_policy.AmazonRDSFullAccess.arn
}

# Redshit -IAM role


#create redshift-customize role with s3 readonly access permission.

resource "aws_iam_role_policy" "s3-full-access-policy" {
  name = "redshift-s3-policy"
  role = aws_iam_role.demo-redshift-role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = ["s3:*"]
            Resource = "*"
        },
]
})

}


resource "aws_iam_role" "demo-redshift-role" {
  name = "demo-redshift-role"
 
assume_role_policy = jsonencode({

  Version = "2012-10-17"
  Statement = [ 
    {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid = ""
      Principal = {
      Service = "redshift.amazonaws.com"
      }      
    },
  ]
})

tags = {
    tag-key = "demo-redshift-role"
  }
}
