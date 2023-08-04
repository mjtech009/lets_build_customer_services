
resource "null_resource" "setup" {
  depends_on = [aws_instance.this]
  connection {
    type        = "ssh"
    host        = aws_instance.this.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.pem.private_key_pem
    timeout     = "5m"
  }

  provisioner "file" {
    content     = null_resource.compose.triggers.user_data
    destination = "/home/ubuntu/docker-compose.yaml"
  }
  provisioner "remote-exec" {

    inline = [
      "sleep 90",
      "sudo chmod 777 /var/log/docker.sock",
      "cd /home/ubuntu",
      "docker-compose up -d",
      "nohup docker-compose logs &"
    ]
  }
}
