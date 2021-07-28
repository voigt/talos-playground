terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "master" {
  name   = "control-plane-${var.index+1}"
  size   = var.instance_size
  image  = var.talos_image_id
  region = var.region
  private_networking = true
  ssh_keys = var.ssh_keys
  user_data = var.controlplane_config

  tags = var.controlplane_tags
}
