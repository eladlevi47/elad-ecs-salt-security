###########################################
###s3 Bucket for qprivacy-dev-client-policy
###########################################

module "s3_bucket_html_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = "html-bucket-elad"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  versioning = {
    enabled = false
  }
}

# Upload the html file to s3 bucket
resource "aws_s3_object" "object-upload-s3" {
  bucket   = module.s3_bucket_html_bucket.s3_bucket_id
  key      = "index.html"
  source   = "./index.html"
  content_type = "text/html"
  depends_on = [
    module.s3_bucket_html_bucket
  ]
}
