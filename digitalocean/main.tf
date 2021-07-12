terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "2.23.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  // populate DIGITALOCEAN_ACCESS_TOKEN environment variable
}

# module "talos_loadbalancer" {
#   source = "./loadbalancer"

#   talos_image_id = var.talos_image_id
#   stage          = var.stage

# }

# output "talos_loadbalancer_ip" {
#     value = module.talos_loadbalancer.loadbalancer_ip
# }

module "control_plane" {
  source = "./control_plane"

  count = var.control_plane_count

  index = count.index
  stage = var.stage
  instance_size   = var.instance_size
  talos_image_id  = var.talos_image_id
  region = var.region
  controlplane_config = "${file("./controlplane.yaml")}"

  depends_on = [
    # module.talos_loadbalancer,
  ]

  #tags = ["control-plane", "master", "reply", "test", "talos"]
}

output "control_plane" {
    value = module.control_plane
}

provider "cloudflare" {}

variable "zone_id" {
  default = "5135e0adad7dabaa3699abac5bba8559"
}

resource "cloudflare_record" "talos" {
  count = var.control_plane_count
  zone_id = var.zone_id
  name    = "talos"
  #value   = each.value.controle_plane_ip
  value   = module.control_plane[count.index].controle_plane_ip
  type    = "A"
  proxied = false
}