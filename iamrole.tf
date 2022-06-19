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
========================EMR-Role===============================
  
# IAM role for EMR Service

resource "aws_iam_role" "emr-role" {
  name = "emr-role"

  assume_role_policy = jsonencode({
  Version = "2008-10-17"
  Statement = [
    {
       Action = "sts:AssumeRole"
       Effect = "Allow"
       Sid = ""
       Principal = {
       Service = "elasticmapreduce.amazonaws.com" 
      }
    },
  ]
})

resource "aws_iam_role_policy" "emr-role-policy" {
  name = "emr-role-policy"
  role = aws_iam_role.emr-role.id

  policy = jsonencode({
     Version = "2012-10-17",
     Statement = [{
       Effect = "Allow",
       Resource = "*",
        Action = [
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CancelSpotInstanceRequests",
            "ec2:CreateNetworkInterface",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteTags",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances",
            "ec2:DescribeKeyPairs",
            "ec2:DescribeNetworkAcls",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribePrefixLists",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSpotInstanceRequests",
            "ec2:DescribeSpotPriceHistory",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeVpcEndpointServices",
            "ec2:DescribeVpcs",
            "ec2:DetachNetworkInterface",
            "ec2:ModifyImageAttribute",
            "ec2:ModifyInstanceAttribute",
            "ec2:RequestSpotInstances",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:DeleteVolume",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfiles",
            "iam:ListRolePolicies",
            "iam:PassRole",
            "s3:CreateBucket",
            "s3:Get*",
            "s3:List*",
            "sdb:BatchPutAttributes",
            "sdb:Select",
            "sqs:CreateQueue",
            "sqs:Delete*",
            "sqs:GetQueue*",
            "sqs:PurgeQueue",
            "sqs:ReceiveMessage"
        ]
    }]
})
}
