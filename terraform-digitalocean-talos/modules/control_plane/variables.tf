variable "talos_image_id" {}
variable "instance_size" {}
variable "region" {}
variable "controlplane_config" {}
variable "ssh_keys" {
  default = []
}

variable "controlplane_tags" {
  default = ["control-plane", "master"]
}

variable "index" {
  type = number
}
