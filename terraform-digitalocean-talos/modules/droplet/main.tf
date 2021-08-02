terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "master" {
  name   = var.name
  size   = var.instance_size
  image  = var.talos_image_id
  region = var.region
  private_networking = true
  ssh_keys = var.ssh_keys
  user_data = var.user_data

  tags = var.tags
}
