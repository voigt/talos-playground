#!/bin/sh
#
# This script is used for generation of various Talos cluster certificates

CONF_DIR="/tmp"
HOST_ARCH=$(uname -m | awk '{print ($1=="x86_64") ? "amd64" : "arm64"}')

function check_deps {
  [[ -f $(which jq) ]] || { echo "jq command not detected in path, please install it";  exit 404; }
}

function parse_inputs {
  eval "$(jq -r '@sh "CONF_DIR=\(.conf_dir)"')"
  if [[ -z "${CONF_DIR}" ]]; then
    echo "Failed to parse input arguments"
    exit 400 # http 400 - bad request
  fi
}

function gen_certs {
  mkdir -p "${CONF_DIR}"
  cd "${CONF_DIR}"

  # Generate Talos Machine CA certificate (Ed25519)
  talosctl gen ca --hours 87600 --organization talos

  # Generate Kubernetes CA certificate (RSA 4096)
  talosctl gen ca --rsa --hours 87600 --organization kubernetes

  # Generate the etcd CA certificate (RSA 4096)
  talosctl gen ca --rsa --hours 87600 --organization etcd

  # Generate the aggregator CA certificate (RSA 4096)
  talosctl gen ca --rsa --hours 87600 --organization aggregator

  # Generate ServiceAccount Key
  openssl ecparam -name prime256v1 -genkey -noout -out sa.pem

  # Generate the Talos admin certificate (Ed25519)
  talosctl gen key --name admin
  talosctl gen csr --ip "127.0.0.1" --key admin.key
  talosctl gen crt  --name admin --hours 87600 --ca talos --csr admin.csr
}

function get_b64_strings {
  # The current directory, because of gen_certs function, is CONF_DIR
	if (uname -a | grep 'Darwin' >/dev/null); then # Host is macOS
    TALOS_CRT=$(base64 -i talos.crt | tr -d '\n')
    TALOS_KEY=$(base64 -i talos.key | tr -d '\n')
    KUBE_CRT=$(base64 -i kubernetes.crt | tr -d '\n')
    KUBE_KEY=$(base64 -i kubernetes.key | tr -d '\n')
    ETCD_CRT=$(base64 -i etcd.crt | tr -d '\n')
    ETCD_KEY=$(base64 -i etcd.key | tr -d '\n')
    ADMIN_CRT=$(base64 -i admin.crt | tr -d '\n')
    ADMIN_KEY=$(base64 -i admin.key | tr -d '\n')
    AGGREGATOR_CRT=$(base64 -i aggregator.crt | tr -d '\n')
    AGGREGATOR_KEY=$(base64 -i aggregator.key | tr -d '\n')
    SA_KEY=$(base64 -i sa.pem | tr -d '\n')
	else # Host is Linux, as other platforms are not tested to be evaluated here
    TALOS_CRT=$(base64 talos.crt | tr -d '\n')
    TALOS_KEY=$(base64 talos.key | tr -d '\n')
    KUBE_CRT=$(base64 kubernetes.crt | tr -d '\n')
    KUBE_KEY=$(base64 kubernetes.key | tr -d '\n')
    ETCD_CRT=$(base64 etcd.crt | tr -d '\n')
    ETCD_KEY=$(base64 etcd.key | tr -d '\n')
    ADMIN_CRT=$(base64 admin.crt | tr -d '\n')
    ADMIN_KEY=$(base64 admin.key | tr -d '\n')
    AGGREGATOR_CRT=$(base64 aggregator.crt | tr -d '\n')
    AGGREGATOR_KEY=$(base64 aggregator.key | tr -d '\n')
    SA_KEY=$(base64 sa.pem | tr -d '\n')
  fi

  # Delete certificate files
  find "${CONF_DIR}" -type f -not -name '*.iso' -not -name '*.yaml' -not -name 'talosconfig' -delete

  jq -n \
    --arg host_arch "${HOST_ARCH}" \
    --arg talos_crt "${TALOS_CRT}" \
    --arg talos_key "${TALOS_KEY}" \
    --arg kube_crt "${KUBE_CRT}" \
    --arg kube_key "${KUBE_KEY}" \
    --arg etcd_crt "${ETCD_CRT}" \
    --arg etcd_key "${ETCD_KEY}" \
    --arg admin_crt "${ADMIN_CRT}" \
    --arg admin_key "${ADMIN_KEY}" \
    --arg aggregator_crt "${AGGREGATOR_CRT}" \
    --arg aggregator_key "${AGGREGATOR_KEY}" \
    --arg sa_key "${SA_KEY}" \
    '{"host_arch": ($host_arch), "talos_crt": ($talos_crt), "talos_key": ($talos_key), "kube_crt": ($kube_crt), "kube_key": ($kube_key), "etcd_crt": ($etcd_crt), "etcd_key": ($etcd_key), "admin_crt": ($admin_crt), "admin_key": ($admin_key), "aggregator_crt": ($aggregator_crt), "aggregator_key": ($aggregator_key), "sa_key": ($sa_key)}'
}

check_deps &&
parse_inputs &&
gen_certs &&
get_b64_strings
