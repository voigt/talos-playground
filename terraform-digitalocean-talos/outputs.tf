output "controlplane_nodes" {
  description = "The hostname and hostonly IP address assigned to Talos cluster control plane nodes"
#   value       = { for i, v in module.controlplane_vms : v => module.controlplane_vms[i].ipv4_address }
  value       = module.controlplane_vms[0].ipv4_address
}

# output "worker_nodes" {
#   description = "The hostname and hostonly IP address assigned to Talos cluster worker nodes"
#   value       = { for vm in var.worker_nodes : vm => module.worker_vms[vm].vm_ip }
# }

// LoadBalancer?