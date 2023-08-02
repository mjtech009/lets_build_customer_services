resource "null_resource" "plain_user_data" {
  triggers = {
    user_data = templatefile("${path.module}/scripts/server.sh", {
      username = var.cust_detail["user_id"]
      password = local.password

    })
  }
}

resource "null_resource" "compose" {
  triggers = {
    user_data = templatefile("${path.module}/compose/docker-compose.yaml", {
      username    = var.cust_detail["user_id"]
      db_password = local.db_password

    })
  }
}