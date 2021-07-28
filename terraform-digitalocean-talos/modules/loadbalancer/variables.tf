variable "name" {}
variable "region" {}

output "loadbalancer_ip" {
    value = digitalocean_loadbalancer.public.ip
}
