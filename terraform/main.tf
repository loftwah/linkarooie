resource "digitalocean_droplet" "web" {
  name   = "rails-app"
  region = var.region
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  ssh_keys = [var.ssh_key_id]
  user_data = <<-EOF
              #!/bin/bash
              # Update package list
              apt-get update

              # Install Docker using get.docker.com script
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh
              EOF
}