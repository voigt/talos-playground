# output "controlplane_nodes" {
#   description = "The hostname and hostonly IP address assigned to Talos cluster control plane nodes"
#   value       = { for vm in var.controlplane_nodes : vm => module.controlplane_vms[vm].vm_ip }
# }

# output "worker_nodes" {
#   description = "The hostname and hostonly IP address assigned to Talos cluster worker nodes"
#   value       = { for vm in var.worker_nodes : vm => module.worker_vms[vm].vm_ip }
# }

// LoadBalancer?