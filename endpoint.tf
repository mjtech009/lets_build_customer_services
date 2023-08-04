

resource "aws_service_discovery_private_dns_namespace" "lets-build_namespace" {
  name        = "lets-build.local"
  vpc         = aws_vpc.vpc.id
  description = "Private DNS namespace for lets-build.local"

}


resource "aws_service_discovery_service" "lets-build" {
  name = var.user_id
  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.lets-build_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

# resource "aws_route53_record" "instance_records" {
#   zone_id = aws_route53_zone.private_zone.zone_id
#   name    = "${var.user_id}.lets-build.local"
#   type    = "A"
#   ttl     = "300"

#   records = [aws_instance.this.private_ip]
# }

resource "aws_service_discovery_instance" "lets-build" {
  instance_id = aws_instance.this.id
  service_id  = aws_service_discovery_service.lets-build.id

  attributes = {
    AWS_INSTANCE_IPV4 = aws_instance.this.private_ip
    custom_attribute  = "custom"
  }
}
