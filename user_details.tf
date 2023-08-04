resource "null_resource" "outputs"{
 
  provisioner "local-exec" {
    command = "terraform output > output.txt"
  }
}
