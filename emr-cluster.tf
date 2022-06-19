resource "aws_emr_cluster" "demo-emr-cluster" {
  name          = "demo-emr-cluster"
  release_label = "emr-5.36.0"
  applications  = ["Spark"]

  ec2_attributes {
    key_name 			                    = "emrec2key"
    subnet_id                         = aws_subnet.emr-subnet.id
    emr_managed_master_security_group = aws_security_group.emr-sg01.id
    emr_managed_slave_security_group  = aws_security_group.emr-sg01.id
    instance_profile                  = aws_iam_instance_profile.demo-emr-instance-profile.arn
  }

  master_instance_group {
    instance_type = "m5.xlarge"
  }



resource "aws_iam_instance_profile" "demo-emr-instance-profile" {
  name = "demo-emr-instance-profile"
  role = aws_iam_role.demo-emr-ec2-profile-role.name
}
