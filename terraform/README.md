# Terraform

This is how to run Terraform.

```bash
terraform init
terraform apply -var="do_token=YOUR_DIGITALOCEAN_TOKEN"

ssh root@<ip-address>
```

* Create the instance with Terraform
* Collect the droplet IP address
* Check for access `ssh root@<ip-address>`

## GitHub Secrets

Ensure you have the following secrets set in your GitHub repository:

* `DROPLET_IP`: The IP address of your DigitalOcean Droplet.
* `DROPLET_SSH_PRIVATE_KEY`: The private SSH key to access your DigitalOcean Droplet.
* `GH_PAT`: Your GitHub Personal Access Token.
