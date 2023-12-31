

variable "REGION" {
  type = string
}



variable "vpc-cidr" {
  type    = string
  default = "10.1"
}


variable "region" {
  type = string

}

variable "instance_type_map" {
  type = map(string)
  default = {
    "free"    = "t3.micro"
    "basic"   = "t3.medium"
    "premium" = "t3.large"
  }
}

variable "volume_size_map" {
  type = map(string)
  default = {
    "free"    = "20"
    "basic"   = "50"
    "premium" = "100"
  }
}

variable "cust_name" {
    type = string
}
variable "plan" {
    type = string
}
variable "user_id" {
    type = string
}


