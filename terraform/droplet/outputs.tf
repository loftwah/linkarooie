output "droplet_ip" {
  description = "The IP address of the Droplet"
  value       = digitalocean_droplet.web.ipv4_address
}
