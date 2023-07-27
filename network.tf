data "aws_availability_zones" "available" {}

# If condition for excluding "us-east-1e" AZ from N.Virginia region as EKS is not available in this AZ
locals {
  az = data.aws_availability_zones.available.names
  az_length = data.aws_availability_zones.available.names
  az_count = var.region == "us-east-1" ? length(setsubtract(local.az_length, ["us-east-1e"])) : length(data.aws_availability_zones.available.names)
  az_name  =  var.region == "us-east-1" ? setsubtract(local.az, ["us-east-1e"]) : data.aws_availability_zones.available.names
}

# var.region == "us-east-1" ? [setsubtract(local.az, ["us-east-1e"])] :
output "az_name" {
  value = local.az_name
}


# Creating VPC

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc-cidr}.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${local.id}-${var.plan}-vpc"
  }
}



# Creating Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.vpc-cidr}.${1 + count.index}.0/24"
  availability_zone       = var.region == "us-east-1"? local.az_name[count.index] : length(data.aws_availability_zones.available.names)
  map_public_ip_on_launch = true
  tags = {
    Name                     = "${local.id}-${var.plan}-Public_Subnet_${1 + count.index}"
    "kubernetes.io/role/elb" = 1

  }
} 


 #Creating private Subnets
resource "aws_subnet" "private_subnet" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.vpc-cidr}.${11 + count.index}.0/24"
  availability_zone       = var.region == "us-east-1"? local.az_name[count.index] : length(data.aws_availability_zones.available.names)
  map_public_ip_on_launch = false
  tags = {
    Name = "${local.id}-${var.plan}-Private_Subnet_${1 + count.index}"

  }
} 


# Creater IGW 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.id}-${var.plan}-IGW"
  }
}

# Creater Public route Table
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "${local.id}-${var.plan}-Public_Route_Table"

  }
}

# Create Nat gateway EIP
resource "aws_eip" "nat-ip" {
  vpc = true

  tags = {
    Name = "${local.id}-${var.plan}-NAT_EIP"
  }
}



# Create Nat gateway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat-ip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "${local.id}-${var.plan}-NAT_Gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create private Route
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "a" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "b" {
  count          = local.az_count
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
} 

