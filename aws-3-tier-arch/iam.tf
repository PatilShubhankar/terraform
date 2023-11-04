#Create IAM Role for EC2 Instance 
resource "aws_iam_role" "role-for-ec2-instance" {
  name = "S3-read-access-to-download-code"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "ec2.amazonaws.com"
            ]
          },
          "Action" : "sts:AssumeRole"
      }]
  })
}


#AWS polcy for S3 to attach code 
resource "aws_iam_policy" "S3-read-policy-for-code" {
  name        = "S3-read-policy-to-download-code"
  description = "S3-read-policy-to-download-code"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : ["*"]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "role-attachment-for-ec2" {
  name       = "S3-policy-attachment-for-ec2-role"
  roles      = [aws_iam_role.role-for-ec2-instance.name]
  policy_arn = aws_iam_policy.S3-read-policy-for-code.arn
}

resource "aws_iam_instance_profile" "instance-profile-for-ec2" {
  name = "EC2-instance-profile"
  role = aws_iam_role.role-for-ec2-instance.name
}
