resource "aws_route53_zone" "private_zone" {
  name = "lets-build.local"
}

resource "aws_service_discovery_private_dns_namespace" "lets-build_namespace" {
  name                = "lets-build"
  vpc                 = aws_vpc.vpc.id  
  description         = "Private DNS namespace for lets-build.local"

}

resource "aws_service_discovery_service" "lets-build" {
  name              = "lets-build"
  dns_namespace_id = aws_service_discovery_private_dns_namespace.lets-build_namespace.id
}

resource "aws_route53_record" "instance_records" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "server.lets-build.local"
  type    = "A"
  ttl     = "300"

  records = [aws_instance.this.private_ip]
}

resource "aws_service_discovery_service_instance" "81_instances" {
  count            = length(var.instance_ips)
  service_id       = aws_service_discovery_service.lets-build.id
  instance_id      = "server" 
  instance_ip      = [aws_instance.this.private_ip]
  instance_port    = 81 
  custom_attributes = {}
}

resource "aws_service_discovery_service_instance" "3306_instances" {
  count            = length(var.instance_ips)
  service_id       = aws_service_discovery_service.lets-build.id
  instance_id      = "server" 
  instance_ip      = [aws_instance.this.private_ip]
  instance_port    = 3306 
  custom_attributes = {}
}

resource "aws_service_discovery_service_instance" "15672_instances" {
  count            = length(var.instance_ips)
  service_id       = aws_service_discovery_service.lets-build.id
  instance_id      = "server" 
  instance_ip      = [aws_instance.this.private_ip]
  instance_port    = 15672 
  custom_attributes = {}
}