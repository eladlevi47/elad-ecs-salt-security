#################################
#### Cloudfront distribution ####
#################################

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_lb.app_lb.dns_name
    origin_id   = aws_lb.app_lb.dns_name
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }
  origin {
    domain_name = module.s3_bucket_html_bucket.s3_bucket_bucket_domain_name
    origin_id   = module.s3_bucket_html_bucket.s3_bucket_bucket_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Elad Levi Cloudfront"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = module.s3_bucket_html_bucket.s3_bucket_bucket_domain_name

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/v1/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.app_lb.dns_name

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = false
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["IR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  depends_on = [
    module.s3_bucket_html_bucket, aws_s3_object.object-upload-s3
  ]
}

###########################################
#### Cloudfront origin access identity ####
###########################################

resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = "cloudfront_oai"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${module.s3_bucket_html_bucket.s3_bucket_arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }
}
#################################
#### cloudfront_cache_policy ####
#################################

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3_bucket_html_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}
