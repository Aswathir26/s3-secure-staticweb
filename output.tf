output "bucket_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.main_bucket.id
}

output "website_endpoint" {
  value = aws_s3_bucket.main_bucket.website_endpoint
}

output "domain_name_1" {
  value = aws_s3_bucket.main_bucket.id 
}

output "domain_name_2" {
  value = aws_s3_bucket.redirector_bucket.id
}

