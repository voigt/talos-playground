variable "region" {}

variable "talos_image_id" {}

variable "stage" {}

variable "lb_dns" {}

variable "control_plane_count" {
    type = number
    default = 1
}

variable "instance_size" {
    default="instance_size"
}