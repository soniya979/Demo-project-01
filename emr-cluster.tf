resource "aws_emr_cluster" "demo-emr-cluster" {
  name          = "demo-emr-cluster"
  release_label = "emr-5.36.0"
  applications  = ["Spark"]
  service_role = aws_iam_role.emr-role.id
	log_uri = "s3://project01-data-bucket/emr-logs/"
	tags = {
		name = "EMR cluster created via Terraform"
	}

  ec2_attributes {
    instance_profile                  = aws_iam_instance_profile.demo-emr-instance-profile.arn
    key_name 			      = "emrec2key"
    subnet_id                         = aws_subnet.emr-subnet.id
    emr_managed_master_security_group = aws_security_group.emr-sg01.id
#   emr_managed_slave_security_group  = aws_security_group.emr-sg01.id
    
  }

  master_instance_group {
    name = "EMR Master EC2"
    instance_type = "m5.xlarge"
  }



resource "aws_iam_instance_profile" "demo-emr-instance-profile" {
  name = "demo-emr-instance-profile"
  role = aws_iam_role.demo-emr-ec2-profile-role.name
}
