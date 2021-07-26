# # Update the kubeconfig
# resource "null_resource" "kubeconfig" {
#   provisioner "local-exec" {
#     interpreter = [var.shell, "-c"]
#     command     = "talosctl --talosconfig $TALOSCONFIG -e $NODE_IP -n $NODE_IP kubeconfig --force --force-context-name $CLUSTER_NAME"
#     on_failure  = continue

#     environment = {
#       CLUSTER_NAME = var.kube_cluster_name
#       NODE_IP      = local.talos_ips[0]
#       TALOSCONFIG  = "${abspath(var.conf_dir)}/talosconfig"
#     }
#   }

#   depends_on = [time_sleep.os_install_wait]
# }

# # Remove the cluster, context, and user of Talos cluster, in kubeconfig
# resource "null_resource" "clean_kubeconfig" {
#   for_each = toset([format("%s|%s", var.shell, var.kube_cluster_name)])

#   provisioner "local-exec" {
#     when        = destroy
#     interpreter = [tostring(split("|", each.key)[0])]
#     command     = <<-EOT
#       kubectl config delete-cluster $CLUSTER_NAME
#       kubectl config delete-context $CLUSTER_NAME
#       kubectl config unset users.admin@$CLUSTER_NAME
#     EOT
#     on_failure  = continue

#     environment = {
#       CLUSTER_NAME = split("|", each.key)[1]
#     }
#   }
# }
