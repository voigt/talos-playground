variable "talos_image_id" {}
variable "instance_size" {}
variable "region" {}
variable "user_data" {}
variable "name" {}
variable "ssh_keys" {
  default = []
}

variable "tags" {
  default = []
}

variable "index" {
  type = number
}
