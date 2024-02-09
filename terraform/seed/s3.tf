# Create S3 with private ACL for storing the split states for a single stage
resource "aws_s3_bucket" "terraform" {
  count = length(var.stages)

  bucket = "${var.prefix}-${var.stages[count.index]}-tf-states"
  force_destroy = true

  tags = {
    Name  = "${var.prefix}-${var.stages[count.index]}-tf-states"
    Environment = "${var.stages[count.index]}"
  }
}

resource "aws_s3_bucket_versioning" "terraform" {
  count = length(var.stages)
  bucket = aws_s3_bucket.terraform[count.index].id # aws_s3_bucket.terraform.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "terraform" {
  count = length(var.stages)
  bucket = aws_s3_bucket.terraform[count.index].id # aws_s3_bucket.terraform.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform" {
  count = length(var.stages)
  depends_on = [aws_s3_bucket_ownership_controls.terraform]

  bucket = aws_s3_bucket.terraform[count.index].id # aws_s3_bucket.terraform.id
  acl    = "private"
}