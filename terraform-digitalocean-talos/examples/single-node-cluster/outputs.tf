output "talos_cluster" {
  description = "The hostname and hostonly IP address of Talos cluster nodes"
  # value       = merge(module.talos.controlplane_nodes)
  value       = module.talos.controlplane_nodes
}