terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "master" {
  name   = "talos-${var.stage}-control-plane-${var.index+1}"
  size   = var.instance_size
  image  = var.talos_image_id
  region = var.region
  private_networking = true
  ssh_keys = ["30756593"]
  user_data = var.controlplane_config

  tags = ["control-plane", "master", "reply", "test", "talos"]
}

output "controle_plane_ip" {
  value = digitalocean_droplet.master.ipv4_address
}
