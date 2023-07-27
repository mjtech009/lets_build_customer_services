# resource "aws_s3_bucket_object" "object" {
#   bucket   = "data.aws_s3_bucket.this.id"
#   key      = "${local.id}-lets-build.pem"
#   acl      = "private"
#   content   = "${aws_key_pair.pem.key_name}.pem"

# # data "aws_s3_bucket" "this" {
# #     bucket=var.bucket
# # }
# }