terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}

variable "do_token" {
  description = "DigitalOcean API token"
}

variable "spaces_access_id" {
  description = "Access Key ID for DigitalOcean Spaces"
}

variable "spaces_secret_key" {
  description = "Secret Access Key for DigitalOcean Spaces"
}

variable "region" {
  description = "DigitalOcean region"
  default     = "syd1"
}

resource "digitalocean_spaces_bucket" "sqlite_backup" {
  name   = "sqlite-backup-bucket"
  region = var.region

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "cleanup-old-backups"
    enabled = true
    prefix  = "backup/"
    expiration {
      days = 30
    }
    noncurrent_version_expiration {
      days = 7
    }
  }

  force_destroy = false
}

output "spaces_bucket_name" {
  value       = digitalocean_spaces_bucket.sqlite_backup.name
  description = "The name of the DigitalOcean Space bucket created."
}

output "spaces_bucket_region" {
  value       = digitalocean_spaces_bucket.sqlite_backup.region
  description = "The region of the DigitalOcean Space bucket created."
}

output "spaces_bucket_domain_name" {
  value       = digitalocean_spaces_bucket.sqlite_backup.bucket_domain_name
  description = "The full domain name of the DigitalOcean Space bucket."
}
