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
  type = string
  default = "10.1"
}




variable "plan"{
  type = string
  default = "free"
}

variable "cust_name" {
  type=string
  
}

variable "region" {
  type=string
  
}


