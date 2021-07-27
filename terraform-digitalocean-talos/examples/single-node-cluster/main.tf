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

  source = "../../"
}
