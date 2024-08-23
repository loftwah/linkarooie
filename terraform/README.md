# Terraform

This is how to run Terraform.

```bash
terraform init
terraform apply -var="do_token=YOUR_DIGITALOCEAN_TOKEN"

ssh root@<ip-address>
```

- Terraform for Spaces.

> Note: `export DO_TOKEN=<token>` and also `SPACES_ACCESS_KEY_ID` and `SPACES_SECRET_ACCESS_KEY` before running this.

```bash
terraform apply -var="do_token=$DO_TOKEN" \
                -var="spaces_access_id=$SPACES_ACCESS_KEY_ID" \
                -var="spaces_secret_key=$SPACES_SECRET_ACCESS_KEY"
```

* Create the instance with Terraform
* Collect the droplet IP address
* Check for access `ssh root@<ip-address>`

- Or for spaces.

```bash
spaces_bucket_domain_name = "sqlite-backup-bucket.syd1.digitaloceanspaces.com"
spaces_bucket_name = "sqlite-backup-bucket"
spaces_bucket_region = "syd1"
```

## GitHub Secrets

Ensure you have the following secrets set in your GitHub repository:

* `DROPLET_IP`: The IP address of your DigitalOcean Droplet.
* `DROPLET_SSH_PRIVATE_KEY`: The private SSH key to access your DigitalOcean Droplet.
* `GH_PAT`: Your GitHub Personal Access Token.
