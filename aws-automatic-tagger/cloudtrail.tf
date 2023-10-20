resource "aws_cloudtrail" "cloudtrail_autotag" {
  count                      = var.create_trail ? 1 : 0
  name                       = "autotag-trail"
  s3_bucket_name             = aws_s3_bucket.cloudtrail_bucket[count.index].id
  enable_log_file_validation = true
}

resource "random_pet" "cloudtrail_bucket_name" {
  prefix = "cloudtrail-autotag"
  count  = var.create_trail ? 1 : 0
}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  count         = var.create_trail ? 1 : 0
  bucket        = random_pet.cloudtrail_bucket_name[count.index].id
  force_destroy = true
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  count  = var.create_trail ? 1 : 0
  bucket = aws_s3_bucket.cloudtrail_bucket[count.index].id
  policy = data.aws_iam_policy_document.cloudtrail_bucket_policy_doc[count.index].json
}