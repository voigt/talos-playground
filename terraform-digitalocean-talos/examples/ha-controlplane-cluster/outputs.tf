output "talos_cluster" {
  description = "The hostname and hostonly IP address of Talos cluster nodes"
  value       = {
    controlplane_nodes = module.talos.controlplane_nodes,
    cluster_endpoint = module.talos.control_plane_loadbalancer_ip
  }
}
