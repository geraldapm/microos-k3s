# K3s MicroOS provisioning with Ignition way

## Prerequisites

- An Installed Linux System with KVM capabilities
- MicroOS cloud image with qcow2 format. Download it from there -> https://get.opensuse.org/microos
- Butane binary executable to convert butane definition into ignition file. Download it from there -> https://github.com/coreos/butane/releases

## Installing

- Copy the downloaded qcow2 file to working directory.
- Edit the following env from scripts [./start-microos.sh](./start-microos.sh)

```bash
# Change the hostname and node count. Note that the provisioning will be sequential.
vms=(
    "gpmcontrolplane1"
    "gpmcontrolplane2"
    "gpmcontrolplane3"
    "gpmworker1"
    "gpmworker2"
)

# MicroOS cloud image file path
TEMPLATE_DISK_FILE="$CURRENT_DIR/opensuse-microos.qcow2"

# Modify CPU, Memory, and network interface. It is homogenous for all node. Change depending on needs.
VCPU=2
MEMORY_MB=2048
NETWORK_IFACE=virbr0

# Default POD CIDR & Service CIDR
POD_CIDR=10.244.0.0/16
SERVICE_CIDR=10.96.0.0/12

# Default IP Network Range from KVM
IP_SUBNET=192.168.122.0/24
IP_RANGE_START=100
IP_RANGE_CONTROLPLANE1=101

# K3s provisioning token. Change depending on needs.
K3S_TOKEN="K3S_SECRET_TOKEN"
```

- Edit the following env from scripts [./stop-microos.sh](./stop-microos.sh)

```bash
### Change the hostname and node count
vms=(
    "gpmcontrolplane1"
    "gpmcontrolplane2"
    "gpmcontrolplane3"
    "gpmworker1"
    "gpmworker2"
)
```

- Start the VMs

```bash
bash start-microos.sh
```

- Wait for about 10 minutes to ensure that the cluster is fully provisioned.
- Verify installation (default root password is "12345")

```bash
ssh root@<controlplanenode> k3s kubectl get node
```

- Copy kubeconfig to local if needed (requires kubectl)

```bash
# Setup kubeconfig
mkdir -p ~/.kube
scp root@<controlplanenode>:/etc/rancher/k3s/k3s.yaml ~/.kube/config
chown -R $(id -u):$(id -g) ~/.kube/config
chmod 600 ~/.kube/config

sed -i "s/127.0.0.1/$IP_FLOATING/" ~/.kube/config
```

- Use with your needs, feel free to play with the K3s Cluster.

## Cleanup

Destroy the VMs

```bash
bash start-microos.sh
```
