
resource "aws_s3_bucket" "dev-remote-state-bucket" {
  bucket = "dev-shubhankar-remote-state-bucket"

  tags = {
    Name = "S3 remote terraform backend store"
  }
}

resource "aws_s3_bucket_versioning" "versioning-remote-backend" {
  bucket = aws_s3_bucket.dev-remote-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}