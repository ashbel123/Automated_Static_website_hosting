resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = var.bucket_name  # Replace with your bucket name
  acl    = "public-read"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_object" "static_files" {
  for_each = fileset("${path.module}/zomato_clone", "**")
  bucket   = aws_s3_bucket.static_website.id
  key      = each.key
  source   = "${path.module}/zomato_clone/${each.key}"
  content_type = lookup(
    {
      ".html" = "text/html"
      ".css"  = "text/css"
      ".js"   = "application/javascript"
      ".png"  = "image/png"
      ".jpg"  = "image/jpeg"
    }, regex("\\.[^.]+$", each.key), "application/octet-stream"
  )
}



