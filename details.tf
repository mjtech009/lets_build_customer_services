resource "aws_s3_bucket" "private_bucket" {
  bucket = "private-lets-build"  
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "pem_key_object" {
  bucket = aws_s3_bucket.private_bucket.id
  key    = "${var.cust_detail.user_id}.pem"
 content  = tls_private_key.pem.private_key_pem
}

resource "aws_s3_bucket_object" "details_object" {
  bucket = aws_s3_bucket.private_bucket.id
  key    = "${var.cust_detail.user_id}.pem"
 content  = tls_private_key.pem.private_key_pem
}
  
