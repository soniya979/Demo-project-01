resource "aws_iam_instance_profile" "demo-emr-instance-profile" {
  name = "demo-emr-instance-profile"
  role = aws_iam_role.emr-ec2-profile-role.name
}
