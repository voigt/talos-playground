variable "name" {}
variable "region" {}
variable "droplet_tag" {
    default = "control-plane"
}

output "loadbalancer_ip" {
    value = digitalocean_loadbalancer.public.ip
}
