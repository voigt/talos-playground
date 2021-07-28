module "talos" {
  controlplane_nodes         = var.controlplane_nodes
  kube_cluster_name          = "capi"
  dns_domain                 = var.dns_domain
  kube_dns_domain            = var.kube_dns_domain
  talos_version              = var.talos_version
  controlplane_scheduling    = true
  conf_dir                   = var.conf_dir
  controlplane_instance_size = var.controlplane_instance_size
  region                     = var.region
  talos_image_id             = var.talos_image_id
  ssh_keys                   = var.ssh_keys

  source = "../../"
}

# provider "cloudflare" {}

# variable "zone_id" {
#   default = "5135e0adad7dabaa3699abac5bba8559"
# }

# resource "cloudflare_record" "talos" {
#   count = var.control_plane_count
#   zone_id = var.zone_id
#   name    = "talos"
#   #value   = each.value.controle_plane_ip
#   value   = module.control_plane[count.index].controle_plane_ip
#   type    = "A"
#   proxied = false
# }
