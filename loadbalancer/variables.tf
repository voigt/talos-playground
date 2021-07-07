variable "talos_image_id" {}

variable "stage" {}

variable "lb_dns" {}

output "loadbalancer_ip" {
    value = digitalocean_loadbalancer.public.ip
}
