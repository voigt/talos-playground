# Notes

Get Talos cli

```
$ wget https://github.com/talos-systems/talos/releases/download/v0.11.0/digital-ocean-amd64.tar.gz
$ tar -xvf digital-ocean-amd64.tar.gz
```

Store Image on DO-s3
(upload talos disk.raw.gz manually before)

```
$ doctl --context talos compute image create \
    --region "fra1" \
    --image-description talos-v0.11.0 \
    --image-url  https://reply-talos.fra1.digitaloceanspaces.com/talos_0.11.raw.gz \
    talos_v0.11.0
```


DNS Round Robin:
```
talosctl gen config talos-dev "https://talos.christophvoigt.com:6443"
```

Via Loadbalancer:
```
talosctl gen config talos-reply-dev "https://talos.christophvoigt.com:443"
```


Helper:
```
rm controlplane.yaml join.yaml kubeconfig talosconfig
```

Plan & Apply Terraform
```
$ terraform init
$ terraform plan -var-file="dev.tfvars"
$ terraform apply -var-file="dev.tfvars" -auto-approve
```


Bootstrap Controlplane
```
$ export firstcp=$(terraform output -json control_plane | jq -r '.[0].controle_plane_ip')
$ talosctl --talosconfig talosconfig config endpoint $firstcp
$ talosctl --talosconfig talosconfig config node $firstcp
$ talosctl --talosconfig talosconfig -n $firstcp get bs
$ talosctl --talosconfig talosconfig bootstrap
```

Retrieve kubeconfig

```
$ talosctl --talosconfig talosconfig kubeconfig .
```

Configuration:
https://www.talos.dev/docs/v0.11/guides/editing-machine-configuration/