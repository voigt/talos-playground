locals {
  scripts_dir = "${path.module}/scripts"
}

locals {
#   talos_nodes = length(var.worker_nodes) > 0 ? concat(var.controlplane_nodes, var.worker_nodes) : var.controlplane_nodes
  talos_nodes = module.controlplane_vms
  # Terraform creates the VMs in parallel, and as a result, the order of returned VMs and IPs could be different from the input lists; so match IPs to input VM names
#   talos_ips = length(var.worker_nodes) > 0 ? concat([for v in var.controlplane_nodes : module.controlplane_vms[v].vm_ip], [for v in var.worker_nodes : module.worker_vms[v].vm_ip]) : [for v in var.controlplane_nodes : module.controlplane_vms[v].vm_ip]
  talos_ips = [for i, v in module.controlplane_vms : module.controlplane_vms[i].ipv4_address]

  depends_on = [module.controlplane_vms]
}

data "external" "talos_certificates" {
  program = [var.shell, "${local.scripts_dir}/talos_certificates.sh"]

  query = {
    conf_dir = abspath(var.conf_dir)
  }

# TODO: Add talos_download to make full module
#   depends_on = [null_resource.talos_download]
}

# Generate the Talos PKI token, and Kubernetes bootstrap token
resource "random_string" "random_token" {
  count = 2

  length    = 35
  min_lower = 20
  upper     = false
  special   = false
}

# Generate the Kubernetes bootstrap data encryption key
resource "random_string" "random_key" {
  count  = 1
  length = 32
}

# TODO: Launch Control-Plane
module "controlplane_vms" {
  source = "./modules/control_plane"

  count = var.controlplane_nodes

  index = count.index
  instance_size   = var.controlplane_instance_size
  talos_image_id  = var.talos_image_id
  region = var.region
  controlplane_config = module.controlplane_config.stdout
  ssh_keys = var.ssh_keys

  depends_on = [local_file.controlplane_config, module.controlplane_config]

  # TODO: Tags
  #tags = ["control-plane", "master", "reply", "test", "talos"]
}

# TODO: Launch Workers

# Generate the talosconfig file
resource "local_file" "talosconfig" {
  content = templatefile("${path.module}/talosconfig.tpl", {
    tf_cluster_name    = var.kube_cluster_name
    tf_endpoints       = slice(local.talos_ips, 0, length(module.controlplane_vms))
    tf_talos_ca_crt    = data.external.talos_certificates.result.talos_crt
    tf_talos_admin_crt = data.external.talos_certificates.result.admin_crt
    tf_talos_admin_key = data.external.talos_certificates.result.admin_key
  })
  filename = "${abspath(var.conf_dir)}/talosconfig"

  depends_on = [module.controlplane_vms, data.external.talos_certificates]
}

# # Generate the Talos controlplane.yaml files
resource "local_file" "controlplane_config" {

  content = templatefile("${path.module}/taloscontrolplane.tpl", {
    tf_talos_token      = format("%s.%s", substr(random_string.random_token[0].result, 7, 6), substr(random_string.random_token[0].result, 17, 16))
    tf_type             = "controlplane"
    tf_talos_ca_crt     = data.external.talos_certificates.result.talos_crt
    tf_talos_ca_key     = data.external.talos_certificates.result.talos_key
    tf_host_arch        = data.external.talos_certificates.result.host_arch
    tf_kube_version     = var.kube_version
    tf_talos_version    = var.talos_version
    tf_cluster_endpoint = format("%s.%s", var.kube_cluster_name, var.dns_domain)
    tf_cluster_name     = var.kube_cluster_name
    tf_kube_dns_domain  = var.kube_dns_domain
    tf_kube_token       = format("%s.%s", substr(random_string.random_token[1].result, 5, 6), substr(random_string.random_token[1].result, 15, 16))
    tf_kube_enc_key     = base64encode(random_string.random_key[0].result)
    tf_kube_ca_crt      = data.external.talos_certificates.result.kube_crt
    tf_kube_ca_key      = data.external.talos_certificates.result.kube_key
    tf_etcd_ca_crt      = data.external.talos_certificates.result.etcd_crt
    tf_etcd_ca_key      = data.external.talos_certificates.result.etcd_key
    tf_aggregator_ca_crt = data.external.talos_certificates.result.aggregator_crt
    tf_aggregator_ca_key = data.external.talos_certificates.result.aggregator_key
    tf_sa_ca_key = data.external.talos_certificates.result.sa_key
    tf_allow_scheduling = var.controlplane_scheduling
  })
  filename = "${abspath(var.conf_dir)}/controlplane.yaml"

  depends_on = [data.external.talos_certificates, random_string.random_token, random_string.random_key]
}

# Generate the Talos worker.yaml files

# Provide the Talos configuration yaml files, to the newly booted up VirtualBox VMs
resource "null_resource" "os_install" {
  count = length(local.talos_nodes)

  provisioner "local-exec" {
    interpreter = [var.shell, "-c"]
    command     = <<-EOT
      sleep 300 && talosctl apply-config --insecure --nodes $NODE_IP --file $NODE_CONFIG
    EOT

    environment = {
      APPLY_PAUSE = var.apply_config_wait * count.index
      NODE_IP     = local.talos_ips[count.index]
      NODE_CONFIG = "${abspath(var.conf_dir)}/controlplane.yaml"
    }
  }

#   depends_on = [local_file.controlplane_config, local_file.worker_config]
  depends_on = [local_file.controlplane_config]
}

module "controlplane_config" {
  source  = "matti/resource/shell"
  command = "cat ${abspath(var.conf_dir)}/controlplane.yaml"

  depends = [
    local_file.controlplane_config,
  ]
}

# Wait until Talos cluster nodes (controlplane or worker) are configured
# resource "time_sleep" "os_install_wait" {
#   count = length(local.talos_nodes)

#   create_duration = var.os_installation_wait

#   depends_on = [null_resource.os_install]
# }
