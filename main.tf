terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  // populate DIGITALOCEAN_ACCESS_TOKEN environment variable
}

module "talos_loadbalancer" {
  source = "./loadbalancer"

  talos_image_id = var.talos_image_id
  stage          = var.stage
  lb_dns         = var.lb_dns

}

resource "null_resource" "lb_wait" {
  depends_on = [
    module.talos_loadbalancer,
  ]

  provisioner "local-exec" {
    command = "talosctl gen config talos-reply-dev https://${var.lb_dns}:443"
  }
}

module "control_plane" {
  source = "./control_plane"

  count = 3

  index = count.index
  stage = var.stage
  instance_size   = var.instance_size
  talos_image_id  = var.talos_image_id
  region = var.region
  controlplane_config = "${file("./controlplane.yaml")}"

  depends_on = [
    null_resource.lb_wait,
  ]

  #tags = ["control-plane", "master", "reply", "test", "talos"]
}

resource "null_resource" "controleplane_bootstrap" {
  depends_on = [
    module.control_plane,
  ]

  provisioner "local-exec" {
    command = <<EOT
    talosctl --talosconfig talosconfig config endpoint ${module.control_plane[0].controle_plane_ip} &&\
    talosctl --talosconfig talosconfig config node ${module.control_plane[0].controle_plane_ip} &&\
    talosctl --talosconfig talosconfig bootstrap
EOT
  }
}

output "talos_loadbalancer_ip" {
    value = module.talos_loadbalancer.loadbalancer_ip
}

output "control_plane" {
    value = module.control_plane
}