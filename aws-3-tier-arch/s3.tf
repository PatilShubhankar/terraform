#create s3 bucket for app code

resource "aws_s3_bucket" "app-code-s3-bucket" {
  bucket = "aws-3-tier-app-code-bucket"

  tags = {
    Name = "app-code-s3-bucket"
  }
}

resource "aws_s3_bucket_versioning" "enable-s3-versioning" {
  bucket = aws_s3_bucket.app-code-s3-bucket.bucket

  versioning_configuration {
    status = "Enabled"
  }
}
