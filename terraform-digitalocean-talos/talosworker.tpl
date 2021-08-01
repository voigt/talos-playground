version: v1alpha1 # Indicates the schema used to decode the contents.
debug: false # Enable verbose logging to the console.
persist: true # Indicates whether to pull the machine config upon every boot.
# Provides machine specific configuration options.
machine:
    type: ${tf_type} # Defines the role of the machine within the cluster.
    token: ${tf_talos_token} # The `token` is used by a machine to join the PKI of the cluster.
    # Extra certificate subject alternative names for the machine's certificate.
    certSANs: []
    #   # Uncomment this to enable SANs.
    #   - 10.0.0.10
    #   - 172.16.0.10
    #   - 192.168.0.10

  # Used to provide additional options to the kubelet.
%{if tf_kube_version != "" ~}
    kubelet:
        image: k8s.gcr.io/kube-proxy-${tf_host_arch}:${tf_kube_version} # The `image` field is an optional reference to an alternative kubelet image.
%{else ~}
    kubelet: {}
    # # The `image` field is an optional reference to an alternative kubelet image.
    # image: ghcr.io/talos-systems/kubelet:v1.21.2

    # # The `extraArgs` field is used to provide additional flags to the kubelet.
    # extraArgs:
    #     key: value

    # # The `extraMounts` field is used to add additional mounts to the kubelet container.
    # extraMounts:
    #     - destination: /var/lib/example
    #       type: bind
    #       source: /var/lib/example
    #       options:
    #         - rshared
    #         - rw
%{endif ~}

    # Provides machine specific network configuration options.
    network: {}
    # # `interfaces` is used to define the network interface configuration.
    # interfaces:
    #     - interface: eth0 # The interface name.
    #       cidr: 192.168.2.0/24 # Assigns a static IP address to the interface.
    #       # A list of routes associated with the interface.
    #       routes:
    #         - network: 0.0.0.0/0 # The route's network.
    #           gateway: 192.168.2.1 # The route's gateway.
    #           metric: 1024 # The optional metric for the route.
    #       mtu: 1500 # The interface's MTU.
    #       
    #       # # Bond specific options.
    #       # bond:
    #       #     # The interfaces that make up the bond.
    #       #     interfaces:
    #       #         - eth0
    #       #         - eth1
    #       #     mode: 802.3ad # A bond option.
    #       #     lacpRate: fast # A bond option.

    #       # # Indicates if DHCP should be used to configure the interface.
    #       # dhcp: true

    #       # # DHCP specific options.
    #       # dhcpOptions:
    #       #     routeMetric: 1024 # The priority of all routes received via DHCP.

    #       # # Wireguard specific configuration.

    #       # # wireguard server example
    #       # wireguard:
    #       #     privateKey: ABCDEF... # Specifies a private key configuration (base64 encoded).
    #       #     listenPort: 51111 # Specifies a device's listening port.
    #       #     # Specifies a list of peer configurations to apply to a device.
    #       #     peers:
    #       #         - publicKey: ABCDEF... # Specifies the public key of this peer.
    #       #           endpoint: 192.168.1.3 # Specifies the endpoint of this peer entry.
    #       #           # AllowedIPs specifies a list of allowed IP addresses in CIDR notation for this peer.
    #       #           allowedIPs:
    #       #             - 192.168.1.0/24
    #       # # wireguard peer example
    #       # wireguard:
    #       #     privateKey: ABCDEF... # Specifies a private key configuration (base64 encoded).
    #       #     # Specifies a list of peer configurations to apply to a device.
    #       #     peers:
    #       #         - publicKey: ABCDEF... # Specifies the public key of this peer.
    #       #           endpoint: 192.168.1.2 # Specifies the endpoint of this peer entry.
    #       #           persistentKeepaliveInterval: 10s # Specifies the persistent keepalive interval for this peer.
    #       #           # AllowedIPs specifies a list of allowed IP addresses in CIDR notation for this peer.
    #       #           allowedIPs:
    #       #             - 192.168.1.0/24

    #       # # Virtual (shared) IP address configuration.
    #       # vip:
    #       #     ip: 172.16.199.55 # Specifies the IP address to be used.

    # # Used to statically set the nameservers for the machine.
    # nameservers:
    #     - 8.8.8.8
    #     - 1.1.1.1

    # # Allows for extra entries to be added to the `/etc/hosts` file
    # extraHostEntries:
    #     - ip: 192.168.1.100 # The IP of the host.
    #       # The host alias.
    #       aliases:
    #         - example
    #         - example.domain.tld

    # Used to provide instructions for installations.
    install:
        disk: /dev/sda # The disk used for installations.
        image: ghcr.io/talos-systems/installer:${tf_talos_version} # Allows for supplying the image used to perform the installation.
        bootloader: true # Indicates if a bootloader should be installed.
        wipe: false # Indicates if the installation disk should be wiped at installation time.
        
        # # Look up disk using disk characteristics like model, size, serial and others.
        # diskSelector:
        #     size: 4GB # Disk size.
        #     model: WDC* # Disk model `/sys/block/<dev>/device/model`.

        # # Allows for supplying extra kernel args via the bootloader.
        # extraKernelArgs:
        #     - talos.platform=metal
        #     - reboot=k
    # Features describe individual Talos features that can be switched on or off.
    features:
        rbac: true # Enable role-based access control (RBAC).
    
    # # Used to partition, format and mount additional disks.

    # # MachineDisks list example.
    # disks:
    #     - device: /dev/sdb # The name of the disk to use.
    #       # A list of partitions to create on the disk.
    #       partitions:
    #         - mountpoint: /var/mnt/extra # Where to mount the partition.
    #           
    #           # # The size of partition: either bytes or human readable representation. If `size:` is omitted, the partition is sized to occupy the full disk.

    #           # # Human readable representation.
    #           # size: 100 MB
    #           # # Precise value in bytes.
    #           # size: 1073741824

    # # Allows the addition of user specified files.

    # # MachineFiles usage example.
    # files:
    #     - content: '...' # The contents of the file.
    #       permissions: 0o666 # The file's permissions in octal.
    #       path: /tmp/file.txt # The path of the file.
    #       op: append # The operation to use

    # # The `env` field allows for the addition of environment variables.

    # # Environment variables definition examples.
    # env:
    #     GRPC_GO_LOG_SEVERITY_LEVEL: info
    #     GRPC_GO_LOG_VERBOSITY_LEVEL: "99"
    #     https_proxy: http://SERVER:PORT/
    # env:
    #     GRPC_GO_LOG_SEVERITY_LEVEL: error
    #     https_proxy: https://USERNAME:PASSWORD@SERVER:PORT/
    # env:
    #     https_proxy: http://DOMAIN\USERNAME:PASSWORD@SERVER:PORT/

    # # Used to configure the machine's time settings.

    # # Example configuration for cloudflare ntp server.
    # time:
    #     disabled: false # Indicates if the time service is disabled for the machine.
    #     # Specifies time (NTP) servers to use for setting the system time.
    #     servers:
    #         - time.cloudflare.com

    # # Used to configure the machine's sysctls.

    # # MachineSysctls usage example.
    # sysctls:
    #     kernel.domainname: talos.dev
    #     net.ipv4.ip_forward: "0"

    # # Used to configure the machine's container image registry mirrors.
    # registries:
    #     # Specifies mirror configuration for each registry.
    #     mirrors:
    #         ghcr.io:
    #             # List of endpoints (URLs) for registry mirrors to use.
    #             endpoints:
    #                 - https://registry.insecure
    #                 - https://ghcr.io/v2/
    #     # Specifies TLS & auth configuration for HTTPS image registries.
    #     config:
    #         registry.insecure:
    #             # The TLS configuration for the registry.
    #             tls:
    #                 insecureSkipVerify: true # Skip TLS server certificate verification (not recommended).
    #                 
    #                 # # Enable mutual TLS authentication with the registry.
    #                 # clientIdentity:
    #                 #     crt: TFMwdExTMUNSVWRKVGlCRFJWSlVTVVpKUTBGVVJTMHRMUzB0Q2sxSlNVSklla05DTUhGLi4u
    #                 #     key: TFMwdExTMUNSVWRKVGlCRlJESTFOVEU1SUZCU1NWWkJWRVVnUzBWWkxTMHRMUzBLVFVNLi4u
    #             
    #             # # The auth configuration for this registry.
    #             # auth:
    #             #     username: username # Optional registry authentication.
    #             #     password: password # Optional registry authentication.

    # # Machine system disk encryption configuration.
    # systemDiskEncryption:
    #     # Ephemeral partition encryption.
    #     ephemeral:
    #         provider: luks2 # Encryption provider to use for the encryption.
    #         # Defines the encryption keys generation and storage method.
    #         keys:
    #             - # Deterministically generated key from the node UUID and PartitionLabel.
    #               nodeID: {}
    #               slot: 0 # Key slot number for luks2 encryption.
# Provides cluster specific configuration options.
cluster:
    # Provides control plane specific configuration options.
    controlPlane:
        endpoint: https://${tf_cluster_endpoint}:443 # Endpoint is the canonical controlplane endpoint, which can be an IP address or a DNS hostname.
    # Provides cluster specific network configuration options.
    network:
        dnsDomain: ${tf_kube_dns_domain} # The domain used by Kubernetes DNS.
        # The pod subnet CIDR.
        podSubnets:
            - 10.244.0.0/16
        # The service subnet CIDR.
        serviceSubnets:
            - 10.96.0.0/12
        
        # # The CNI used.
        cni:
            name: custom # Name of CNI to use.
            # URLs containing manifests to apply for the CNI.
            urls:
                - https://raw.githubusercontent.com/cilium/cilium/v1.9/install/kubernetes/quick-install.yaml
    token: ${tf_kube_token} # The [bootstrap token](https://kubernetes.io/docs/reference/access-authn-authz/bootstrap-tokens/) used to join the cluster.
    aescbcEncryptionSecret: "" # The key used for the [encryption of secret data at rest](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/).
    # The base64 encoded root certificate authority used by Kubernetes.
    ca:
        crt: ${tf_kube_ca_crt}
        key: ""
    # The base64 encoded aggregator certificate authority used by Kubernetes for front-proxy certificate generation.
    # aggregatorCA:
    #     crt: ${tf_aggregator_ca_crt}
    #     key: ${tf_aggregator_ca_key}
    # The base64 encoded private key for service account token generation.
    # serviceAccount:
    #     key: ${tf_sa_ca_key}
    # API server specific configuration options.
    # apiServer:
%{if tf_kube_version != "" ~}
        # image: k8s.gcr.io/kube-apiserver-${tf_host_arch}:${tf_kube_version}
%{endif ~}
        # Extra certificate subject alternative names for the API server's certificate.
        # certSANs:
            # - ${tf_cluster_endpoint}
        
        # # The container image used in the API server manifest.
        # image: k8s.gcr.io/kube-apiserver:v1.21.2

    # Controller manager server specific configuration options.
%{if tf_kube_version != "" ~}
    # controllerManager:
        # image: k8s.gcr.io/kube-controller-manager-${tf_host_arch}:${tf_kube_version} # The container image used in the controller manager manifest.
%{else ~}
    # controllerManager: {}

    # # The container image used in the controller manager manifest.
    # image: k8s.gcr.io/kube-controller-manager:v1.21.2
%{endif ~}

    # Kube-proxy server-specific configuration options
%{if tf_kube_version != "" ~}
    # proxy:
        # image: k8s.gcr.io/kube-proxy-${tf_host_arch}:${tf_kube_version}
%{else ~}
    # proxy: {}
    # # The container image used in the kube-proxy manifest.
    # image: k8s.gcr.io/kube-proxy:v1.21.2
%{endif ~}

    # Scheduler server specific configuration options.
%{if tf_kube_version != "" ~}
    # scheduler:
        # image: k8s.gcr.io/kube-scheduler-${tf_host_arch}:${tf_kube_version} # The container image used in the scheduler manifest.
%{else ~}
    # scheduler: {}
    # # The container image used in the scheduler manifest.
    # image: k8s.gcr.io/kube-scheduler:v1.21.2
%{endif ~}

    # Etcd specific configuration options.
    # etcd:
        # The `ca` is the root certificate authority of the PKI.
        # ca:
            # crt: ${tf_etcd_ca_crt}
            # key: ${tf_etcd_ca_key}
        
        # # The container image used to create the etcd service.
        # image: gcr.io/etcd-development/etcd:v3.4.16
    # A list of urls that point to additional manifests.
    # extraManifests: []
    #   - https://www.example.com/manifest1.yaml
    #   - https://www.example.com/manifest2.yaml

    # A list of inline Kubernetes manifests.
    # inlineManifests: []
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
