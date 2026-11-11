
data "aws_iam_policy_document" "public_read_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.bucket.arn
    ]
  }
}

data "aws_iam_policy_document" "read_s3_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.bucket.arn
    ]
  }
}

data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name   = "ec2_role_policy"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.read_s3_document.json
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}
