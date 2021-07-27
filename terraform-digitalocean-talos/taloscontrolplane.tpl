version: v1alpha1 # Indicates the schema used to decode the contents.
debug: false # Enable verbose logging to the console.
persist: true # Indicates whether to pull the machine config upon every boot.

# Provides machine specific configuration options.
machine:
  type: ${tf_type} # Defines the role of the machine within the cluster.
  token: ${tf_talos_token} # The `token` is used by a machine to join the PKI of the cluster.
  # The root certificate authority of the PKI.
  ca:
    crt: ${tf_talos_ca_crt}
    key: ${tf_talos_ca_key}

  # Used to provide additional options to the kubelet.
%{if tf_kube_version != "" ~}
  kubelet:
    image: k8s.gcr.io/kube-proxy-${tf_host_arch}:${tf_kube_version} # The `image` field is an optional reference to an alternative kubelet image.
%{else ~}
  kubelet: {}
%{endif ~}

  # Provides machine specific network configuration options.
  network: {}

  # Used to provide instructions for installations.
  install:
    disk: /dev/sda # The disk used for installations.
    image: ghcr.io/talos-systems/installer:${tf_talos_version} # Allows for supplying the image used to perform the installation.
    bootloader: true # Indicates if a bootloader should be installed.
    wipe: false # Indicates if the installation disk should be wiped at installation time.

  features:
    rbac: true # Enable role-based access control (RBAC).

# Provides cluster specific configuration options.
cluster:
  # Provides control plane specific configuration options.
  controlPlane:
    endpoint: https://${tf_cluster_endpoint}:6443 # Endpoint is the canonical controlplane endpoint, which can be an IP address or a DNS hostname.
  clusterName: ${tf_cluster_name} # Configures the cluster's name.
  # Provides cluster specific network configuration options.
  network:
    dnsDomain: ${tf_kube_dns_domain} # The domain used by Kubernetes DNS.
    # The pod subnet CIDR.
    podSubnets:
      - 10.244.0.0/16
    # The service subnet CIDR.
    serviceSubnets:
      - 10.96.0.0/12

  token: ${tf_kube_token} # The [bootstrap token](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/) used to join the cluster.
  aescbcEncryptionSecret: ${tf_kube_enc_key} # The key used for the [encryption of secret data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
  # The base64 encoded root certificate authority used by Kubernetes.
  ca:
    crt: ${tf_kube_ca_crt}
    key: ${tf_kube_ca_key}
# TODO: Find correct crt/keys for aggregatorCA and serviceAccount
#     # The base64 encoded aggregator certificate authority used by Kubernetes for front-proxy certificate generation.
#     aggregatorCA:
#         crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJYekNDQVFXZ0F3SUJBZ0lRUWpQZTI2aEZsZEkweHFuaHZzYUFyVEFLQmdncWhrak9QUVFEQkRBQU1CNFgKRFRJeE1EY3hNakl3TXpneU0xb1hEVE14TURjeE1ESXdNemd5TTFvd0FEQlpNQk1HQnlxR1NNNDlBZ0VHQ0NxRwpTTTQ5QXdFSEEwSUFCTm1ycmsrSFhLb05aaEhWbUZwUFVMYWx2SXR6NVRsZ0grS3NaaEdud1JVaW9zNmpLbHRTCjlpZ3Z3dTlXL0RUcG5ybk8wOVFsZW1NdmpZN1RpU1FnQ282allUQmZNQTRHQTFVZER3RUIvd1FFQXdJQ2hEQWQKQmdOVkhTVUVGakFVQmdnckJnRUZCUWNEQVFZSUt3WUJCUVVIQXdJd0R3WURWUjBUQVFIL0JBVXdBd0VCL3pBZApCZ05WSFE0RUZnUVVQNHNSRVRDSTUzb3B6d2l1OEhQRGNIeWx3dUV3Q2dZSUtvWkl6ajBFQXdRRFNBQXdSUUloCkFPMG1GUktSa2p6bzR4djFuN0hFbEc5RkkvNmNGS2Q4QlJqOExzbncvTUVuQWlBbjA5YVlVRkk0TkZYRWZGbUUKT2IrdHZVWFhCYk1QWDJEaW1uUHhPTDNmVGc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
#         key: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSUlkYXA4bG04UmJQUC8wb1JIb0ZsRWJWRkdLc05sbEt6bEZTblQ1Wmx3YWhvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFMmF1dVQ0ZGNxZzFtRWRXWVdrOVF0cVc4aTNQbE9XQWY0cXhtRWFmQkZTS2l6cU1xVzFMMgpLQy9DNzFiOE5PbWV1YzdUMUNWNll5K05qdE9KSkNBS2pnPT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo=
#     # The base64 encoded private key for service account token generation.
#     serviceAccount:
#         key: LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1IY0NBUUVFSUhvbFBuUUJSRFA3UmxHa2FjTldOdzlwRzFyWHZTbEw0TUhhWXJ3SnpJbzJvQW9HQ0NxR1NNNDkKQXdFSG9VUURRZ0FFUHI3N25rUTZ2eGNVd3ZOMEZrT2Z3V0E2UUwzZVBQYnlvSm5nV3E5RVVkVGhBaHJHaVBZOQpBeDF5L2tOZTN5ZXNtcmtEbnEyNHJzMTcyKzBxRXVsOXBBPT0KLS0tLS1FTkQgRUMgUFJJVkFURSBLRVktLS0tLQo=

  # API server specific configuration options.
  apiServer:
%{if tf_kube_version != "" ~}
    image: k8s.gcr.io/kube-apiserver-${tf_host_arch}:${tf_kube_version} # The container image used in the API server manifest.
%{endif ~}
    # Extra certificate subject alternative names for the API server's certificate.
    certSANs:
      - ${tf_cluster_endpoint}

  # Controller manager server specific configuration options.
%{if tf_kube_version != "" ~}
  controllerManager:
    image: k8s.gcr.io/kube-controller-manager-${tf_host_arch}:${tf_kube_version} # The container image used in the controller manager manifest.
%{else ~}
  controllerManager: {}
%{endif ~}

  # Kube-proxy server-specific configuration options
%{if tf_kube_version != "" ~}
  proxy:
    image: k8s.gcr.io/kube-proxy-${tf_host_arch}:${tf_kube_version} # The container image used in the kube-proxy manifest.
%{else ~}
  proxy: {}
%{endif ~}

  # Scheduler server specific configuration options.
%{if tf_kube_version != "" ~}
  scheduler:
    image: k8s.gcr.io/kube-scheduler-${tf_host_arch}:${tf_kube_version} # The container image used in the scheduler manifest.
%{else ~}
  scheduler: {}
%{endif ~}

  # Etcd specific configuration options.
  etcd:
    # The `ca` is the root certificate authority of the PKI.
    ca:
      crt: ${tf_etcd_ca_crt}
      key: ${tf_etcd_ca_key}

        # # The container image used to create the etcd service.
        # image: gcr.io/etcd-development/etcd:v3.4.16
  # A list of urls that point to additional manifests.
  extraManifests: []
  #   - https://www.example.com/manifest1.yaml
  #   - https://www.example.com/manifest2.yaml

  # A list of inline Kubernetes manifests.
  inlineManifests: []
  #   - name: namespace-ci # Name of the manifest.
  #     contents: |- # Manifest contents as a string.
  #       apiVersion: v1
  #       kind: Namespace
  #       metadata:
  #       	name: ci

  
  # # Core DNS specific configuration options.
  # coreDNS:
  #     image: docker.io/coredns/coredns:1.8.4 # The `image` field is an override to the default coredns image.

  # # External cloud provider configuration.
  # externalCloudProvider:
  #     enabled: true # Enable external cloud provider.
  #     # A list of urls that point to additional manifests for an external cloud provider.
  #     manifests:
  #         - https://raw.githubusercontent.com/kubernetes/cloud-provider-aws/v1.20.0-alpha.0/manifests/rbac.yaml
  #         - https://raw.githubusercontent.com/kubernetes/cloud-provider-aws/v1.20.0-alpha.0/manifests/aws-cloud-controller-manager-daemonset.yaml

  # # A map of key value pairs that will be added while fetching the extraManifests.
  # extraManifestHeaders:
  #     Token: "1234567"
  #     X-ExtraInfo: info

  # # Settings for admin kubeconfig generation.
  # adminKubeconfig:
  #     certLifetime: 1h0m0s # Admin kubeconfig certificate lifetime (default is 1 year).


allowSchedulingOnMasters: ${tf_allow_scheduling}
