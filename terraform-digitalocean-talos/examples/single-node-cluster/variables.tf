variable "conf_dir" {
  description = "The directory used for storing Talos ISO and cluster build configuration files (default is /tmp)"
  type        = string
  default     = "/tmp"

  validation {
    condition     = var.conf_dir != ""
    error_message = "The Talos configuration directory must be identified."
  }
}

variable "controlplane_nodes" {
    default = 1
}

variable "kube_cluster_name" {
    default = "capi"
}

variable "dns_domain" {
    default = "example.com"
}

variable "kube_dns_domain" {
    default = "k8s.example.com"
}

variable "talos_version" {
    default = "v0.11.3"
}

variable "talos_image_id" {
    default = "88665004"
}

variable "controlplane_scheduling" {
    default = true
}

variable "os_installation_wait" {
    default = "210s"
}

variable "controlplane_instance_size" {
    default = "s-2vcpu-4gb"
}

variable "region" {
    default = "fra1"
}

variable "ssh_keys" {
    default = []
}
