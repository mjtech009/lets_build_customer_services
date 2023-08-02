resource "random_string" "user_password" {
  length           = 16
  special          = false
  override_special = "!@#$%^&*()_+"
}
resource "random_integer" "unique_prefix" {
  min = 0
  max = 9999
}
resource "random_string" "id" {
  length  = 4
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "random_string" "db_password" {
  length           = 16
  special          = false
  override_special = "!@#$%^&*()_+"
}

locals {
  id          = random_string.id.result
  prefix      = random_integer.unique_prefix.result
  password    = random_string.user_password.result
  db_password = random_string.db_password.result
}
