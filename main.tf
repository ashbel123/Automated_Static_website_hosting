resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name  # Replace with your bucket name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
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
    }, regex("\\.[^.]+$"), "application/octet-stream"
  )
}



