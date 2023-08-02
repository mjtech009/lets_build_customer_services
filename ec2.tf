data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



resource "aws_security_group" "this" {
  name   = "${local.id}-main-server"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.23.0.0/16"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${local.id}-main-server"
  }
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type_map[var.plan]
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.pem.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.profile.name

  root_block_device {
    volume_size           = var.volume_size_map[var.plan]
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false
  }
  lifecycle {
    ignore_changes = [
      tags, ami
    ]
  }

  user_data = base64encode(null_resource.plain_user_data.triggers.user_data)
  tags = {
    Id = local.id
    Name = "${var.cust_name}"
  }
}


locals {
  userdata_file = templatefile("${path.module}/scripts/server.sh", {
    username    = "${var.cust_name}-${local.id}"
    password    = "${local.password}"
  })
  userdata_hash = local.userdata_file
}

# locals {
#   userdata_file = "${path.module}/scripts/userdata.sh"
#   userdata_hash = filesha256(local.userdata_file)
# }



resource "aws_iam_instance_profile" "profile" {
  name = "demo_profile"
  role = aws_iam_role.ec2_admin_role.name
}