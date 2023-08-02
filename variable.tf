variable "env" {
  type = string
}

variable "REGION" {
  type = string
}

variable "ACCESS" {
  type = string
}

variable "SECRET" {
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

variable "cust_detail" {
    type = object({
    cust_name = string
    plan      = string
    user_id   = string
  })
}

