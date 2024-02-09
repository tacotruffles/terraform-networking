output "bucket_names" {
  value = { for i in aws_s3_bucket.terraform[*] : i.tags.Environment => i.tags.Name }
}