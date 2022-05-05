# S3 bucket for website.
resource "aws_s3_bucket" "main_bucket" {
  bucket = "${var.domain_name}"
  acl = "public-read"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
                "Resource": "arn:aws:s3:::${var.domain_name}/*"
      },
    ]
  })

  website {
    index_document = "index.html"
    error_document = "error.html"
  } 
}


# mime.json file is to specify the type of files of website
locals {
  mime_types = jsondecode(file("mime.json"))
}

# Add files
resource "aws_s3_bucket_object" "Files" {
 bucket = aws_s3_bucket.main_bucket.id
 for_each = fileset("${var.website_root}/", "*")
  key = each.value
 source = "${var.website_root}/${each.value}"
 content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

# S3 bucket for redirecting to website if needed( for eg: redirect example.com to www.example.com)
resource "aws_s3_bucket" "redirector_bucket" {
  bucket = var.redirector_bucket_name
  acl = "public-read"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
                "Resource": "arn:aws:s3:::${var.redirector_bucket_name}/*"
      },
    ]
  })

  website {
    redirect_all_requests_to = "https://${var.domain_name}"
  }
}