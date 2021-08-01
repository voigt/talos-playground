variable "controlplane_nodes" {
  description = "The number of Talos control plane nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.controlplane_nodes > 0
    error_message = "Number of control plane nodes must be greater than 0."
  }
}

variable "controlplane_instance_size" {
  description = "Controlplane instance size."
  type        = string
  default     = "s-2vcpu-4gb"

  validation {
    condition     = var.controlplane_instance_size != ""
    error_message = "Controlplane instance size must not be empty."
  }
}

variable "worker_nodes" {
  description = "The list of Talos worker nodes (minimum is 0 nodes); the maximum depends on availability of host resources"
  type        = number
  default     = 0

  validation {
    condition     = var.worker_nodes >= 0
    error_message = "Number of worker nodes must be equal or greater than zero."
  }
}

variable "worker_instance_size" {
  description = "Worker instance size."
  type        = string
  default     = "s-2vcpu-4gb"

  validation {
    condition     = var.worker_instance_size != ""
    error_message = "Worker instance size must not be empty."
  }
}

variable "talos_image_id" {
  default = "88665004"
}

variable "region" {
  default = "fra1"
}

variable "ssh_keys" {
  default = []
}

variable "control_plane_tag" {
  default = "control-plane"
}

variable "talos_version" {
  description = "The version of Talos OS, used for building the cluster; the version string should start with 'v'"
  type        = string
  default     = ""

  validation {
    condition     = var.talos_version != "" && substr(var.talos_version, 0, 1) == "v"
    error_message = "The specified Talos version is invalid."
  }
}

# variable "talos_cli_update" {
#   description = "Whether Talos CLI (talosctl) should be installed/updated or not, for the specified Talos version (default is true)"
#   type        = bool
#   default     = true
# }

variable "kube_version" {
  description = "The version of Kubernetes (e.g. 1.20); default is the latest version supported by the selected Talos version"
  type        = string
  default     = ""
}

variable "kube_cluster_name" {
  description = "The Kubernetes cluster name (default is talos)"
  type        = string
  default     = "talos"

  validation {
    condition     = var.kube_cluster_name != ""
    error_message = "The Kubernetes cluster name must be identified."
  }
}

variable "kube_dns_domain" {
  description = "The Kubernetes cluster DNS domain (default is cluster.local)"
  type        = string
  default     = "cluster.local"

  validation {
    condition     = var.kube_dns_domain != ""
    error_message = "The Kubernetes cluster DNS domain must be identified."
  }
}

variable "controlplane_scheduling" {
  description = "Whether the scheduling taint of the Talos cluster control plane nodes should be removed (default is false)"
  type        = bool
  default     = false
}

variable "dns_domain" {
  description = "The DNS domain for the hostonly network; usually the domain host is part of (default is example.com)"
  type        = string
  default     = "example.com"

  validation {
    condition     = var.dns_domain != ""
    error_message = "The specified DNS domain is invalid, or is empty."
  }
}

variable "apply_config_wait" {
  description = "Whether Talos CLI's apply-config should be applied sequentially, by a number of seconds; can ease pressure on host resources (default is 0s)"
  type        = number
  default     = 500

  validation {
    condition     = var.apply_config_wait >= 0
    error_message = "The specified apply config wait time is invalid."
  }
}

# variable "os_installation_wait" {
#   description = "How long Terraform should wait for OS installation; it's host resources, network bandwidth, and image caching dependent (default is 4m)"
#   type        = string
#   default     = "4m"

#   validation {
#     condition     = var.os_installation_wait != ""
#     error_message = "The specified OS installation wait time is invalid."
#   }
# }

variable "conf_dir" {
  description = "The directory used for storing Talos ISO and cluster build configuration files (default is /tmp)"
  type        = string
  default     = "/tmp"

  validation {
    condition     = var.conf_dir != ""
    error_message = "The Talos configuration directory must be identified."
  }
}

variable "shell" {
  description = "The qualified name of preferred shell (e.g. /bin/bash, /bin/zsh, /bin/sh...), to minimize risk of incompatibility (default is /bin/bash)"
  type        = string
  default     = "/bin/bash"

  validation {
    condition     = var.shell != ""
    error_message = "The shell, for exection of scripts, must be identified."
  }
}
