variable "talos_image_id" {}

variable "stage" {}

output "loadbalancer_ip" {
    value = digitalocean_loadbalancer.public.ip
}
