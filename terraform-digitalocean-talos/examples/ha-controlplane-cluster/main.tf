module "talos" {
  kube_cluster_name          = "capi"
  controlplane_scheduling    = true
  controlplane_nodes         = var.controlplane_nodes
  controlplane_instance_size = var.controlplane_instance_size
  dns_domain                 = var.dns_domain
  kube_dns_domain            = var.kube_dns_domain
  talos_version              = var.talos_version
  conf_dir                   = var.conf_dir
  region                     = var.region
  talos_image_id             = var.talos_image_id
  ssh_keys                   = var.ssh_keys

  source = "../../"
}
