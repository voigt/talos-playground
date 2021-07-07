


$ wget https://github.com/talos-systems/talos/releases/download/v0.11.0-beta.2/digital-ocean-amd64.tar.gz
$ tar -xvf digital-ocean-amd64.tar.gz

$ doctl auth init --context talos
> insert DO token

(upload talos disk.raw manually)

doctl compute image create \
    --region fra1 \
    --image-description talos-digital-ocean-tutorial \
    --image-url  https://reply-talos.fra1.digitaloceanspaces.com/disk.raw.gz \
    talos_v0.11.0-beta.2

$ talos doctl --context talos compute image create \
    --region "fra1" \
    --image-description talos-v0.11.0-beta.2 \
    --image-url https://reply-talos.fra1.digitaloceanspaces.com/disk.raw.gz \
    talos_v0.11.0-beta.2
ID          Name                    Type      Distribution    Slug    Public    Min Disk
87347087    talos_v0.11.0-beta.2    custom    Unknown OS              false     0






doctl --context talos compute load-balancer create \
    --region fra1 \
    --name talos-digital-ocean-tutorial-lb \
    --tag-name talos-digital-ocean-tutorial-control-plane \
    --health-check protocol:tcp,port:6443,check_interval_seconds:10,response_timeout_seconds:5,healthy_threshold:5,unhealthy_threshold:3 \
    --forwarding-rules entry_protocol:tcp,entry_port:443,target_protocol:tcp,target_port:6443


talosctl gen config talos-reply-dev https://157.230.78.36:443



talosctl --talosconfig talosconfig config endpoint 138.68.111.7
talosctl --talosconfig talosconfig config node 138.68.111.7
talosctl --talosconfig talosconfig kubeconfig .

142.93.173.138