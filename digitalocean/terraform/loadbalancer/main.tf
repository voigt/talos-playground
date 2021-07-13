terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_loadbalancer" "public" {
  name   = "talos-${var.stage}-lb"
  region = "fra1"

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "tcp"

    target_port     = 6443
    target_protocol = "tcp"
  }

  healthcheck {
    port                     = 6443
    protocol                 = "tcp"
    check_interval_seconds   = 10
    response_timeout_seconds = 5
    healthy_threshold        = 5
    unhealthy_threshold      = 3
  }

  droplet_tag = "control-plane"
}
