resource "aws_s3_bucket" "bucket" {
  bucket = "ec2-bucket-3j2k3"
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "public_read_document" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.public_read_document.json
}
