provider "aws" {
    region = "eu-north-1"
    access_key = ""
    secret_key = ""
}

#Create EC2 instance in default vpc and bootstrap instance to start and install jenkins 
resource "aws_instance" "jenkins-instance" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update –y 
                sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo 
                sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
                sudo yum upgrade
                sudo amazon-linux-extras install java-openjdk11 -y 
                sudo yum install jenkins -y
                sudo systemctl enable jenkins
                sudo systemctl start jenkins
                EOF
    user_data_replace_on_change = true
    tags = { 
        Name = "jenkins-ec2"
    }
}

resource "aws_security_group" "jenkins-sg" {
    name = "jenkins-sg"
    description = "Allow traffic on port 22 and port 8080"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow for SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Port 8080 used for web servers"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "virtual port that computers use to divert netowrk traffic"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_s3_bucket" "jenkins-bucket" {
    bucket = var.s3bucket
    acl = var.acl
    tags = {
        description = "Private bucket to hold Jenkins artificats"
        name = "jenkins-bucket"
    }
}

resource "aws_iam_role" "s3-jenkins-role" {
    name = "s3-jenkins-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
}

resource "aws_iam_instance_profile" "s3-jenkins-instance-profile" {
    name = "s3-jenkins-instance-profile"
    role = aws_iam_role.s3-jenkins-role.name
}


resource "aws_iam_policy" "s3-jenkins-policy" {
    name = "s3-jenkins-policy"
    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.jenkins-bucket.arn}/*",
          "${aws_s3_bucket.jenkins-bucket.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3-jenkins-policy-attachment"{
    policy_arn = aws_iam_policy.s3-jenkins-policy.arn
    role = aws_iam_role.s3-jenkins-role.name
}




