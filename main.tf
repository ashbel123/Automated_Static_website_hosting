resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name  # Replace with your bucket name
  # acl    = "public-read"

  # index_document {
  #   suffix = "index.html"
  # }

  # error_document {
  #   key = "error.html"
  # }
}
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
# Disable Block Public Access
resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_object" "static_files" {
  for_each = fileset("${path.module}/zomato_clone", "**")
  bucket   = aws_s3_bucket.static_website.id
  key      = each.key
  source   = "${path.module}/zomato_clone/${each.key}"
  content_type = lookup(
    {
      ".html" = "text/html"
      ".css"  = "text/css"
      # ".js"   = "application/javascript"
      # ".png"  = "image/png"
      # ".jpg"  = "image/jpeg"
    }, regex("\\.[^.]+$", each.key), "application/octet-stream"
  )
}

# Bucket Policy to Allow Public Access
resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_website.arn}/*"
      }
    ]
  })
}



