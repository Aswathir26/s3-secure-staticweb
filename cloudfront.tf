# Cloudfront distribution for main s3 site.
resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.main_bucket.website_endpoint
    origin_id = "S3-${var.domain_name}"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true
  default_root_object = var.root_object 

  aliases = ["${var.domain_name}"]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code = 404
    response_code = 200
    response_page_path = "/${var.error_object}"
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-${var.domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 31536000
    default_ttl = 31536000
    max_ttl = 31536000
    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #paste the arn of your certificate
    acm_certificate_arn = "arn:aws:acm:us-east-1:969255359775:certificate/1138f666-52b5-4f08-a2ac-897b5218911e"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}

# Cloudfront S3 for redirect to www.
resource "aws_cloudfront_distribution" "root_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.redirector_bucket.website_endpoint
    origin_id = "S3-${var.redirector_bucket_name}"
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true

  aliases = [var.redirector_bucket_name]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "S3-${var.redirector_bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 86400
    max_ttl = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    #paste the arn of your certificate
    acm_certificate_arn = "arn:aws:acm:us-east-1:969255359775:certificate/1138f666-52b5-4f08-a2ac-897b5218911e"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
}



#DNS for website
resource "azurerm_dns_cname_record" "target" {
  name                = var.recordset_name
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = 3600
  record              = aws_cloudfront_distribution.www_s3_distribution.domain_name
}

#DNS to redirect
resource "azurerm_dns_cname_record" "redirector" {
  name                = var.redirector_recordset_name
  zone_name           = var.zone_name
  resource_group_name = var.rg_name
  ttl                 = 3600
  record              = aws_cloudfront_distribution.root_s3_distribution.domain_name
}