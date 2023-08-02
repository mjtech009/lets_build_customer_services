output "Important_Note" {
  value = "This all details are working, when you are connected with VPN"
}

output "Server_endpoint" {
  value = "${var.cust_detail.user_id}.lets-build.local"
}

output "Server_Username" {
  value = var.cust_detail.user_id
}

output "Server_Password" {
  value = local.password
}

output "Mysql_endpoint" {
  value = "${var.cust_detail.user_id}.lets-build.local:3306"
}


output "Mysql_Username" {
  value = var.cust_detail.user_id
}

output "Mysql_Password" {
  value = local.db_password
}

output "phpmyadmin_endpoint" {
  value = "http://${var.cust_detail.user_id}.lets-build.local:81"
}
