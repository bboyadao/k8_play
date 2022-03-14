#!/bin/bash

echo "[COMMON TASK 0] ADD EPEL"
# Centos through VM - no URLs in mirrorlist
# https://stackoverflow.com/questions/70926799/centos-through-vm-no-urls-in-mirrorlist
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
yum install epel-release -y -q

echo "[COMMON TASK 1] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[COMMON TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1
systemctl disable firewalld; systemctl stop firewalld

# Disable SELinux
echo "[COMMON TASK 3] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

echo "[COMMON TASK 5] Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[COMMON TASK 5] Install containerd runtime"
yum install -y -q yum-utils wget iproute-tc
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo >/dev/null 2>&1
yum install -y -q containerd.io
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml

echo "[COMMON TASK 4] Enable containerd"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter


systemctl restart containerd >/dev/null 2>&1
systemctl enable containerd >/dev/null 2>&1

echo "[COMMON TASK 6] Add Registry repo for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

echo "[COMMON TASK 7] Install Kubernetes components (kubeadm, kubelet and kubectl)"
yum install -qq -y kubeadm kubelet kubectl >/dev/null 2>&1
systemctl enable kubelet.service --now
DROPLET_IP_ADDRESS=$(ip -f inet addr show eth1 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p')
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$DROPLET_IP_ADDRESS\"" >> /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

if [ "$HOSTNAME" = master ]; then
    printf '%s\n' "on the right host"
else
    printf '%s\n' "uh-oh, not on foo"
    mkdir -p /mnt/pv0
    mkdir -p /mnt/pv1
    mkdir -p /mnt/pv2
    mkdir -p /mnt/pv3
    sudo mount -t nfs 192.168.1.5:/srv/nfs/pv0 /mnt/pv0
    sudo mount -t nfs 192.168.1.5:/srv/nfs/pv1 /mnt/pv1
    sudo mount -t nfs 192.168.1.5:/srv/nfs/pv2 /mnt/pv2
    sudo mount -t nfs 192.168.1.5:/srv/nfs/pv3 /mnt/pv3
    sudo umount /mnt/pv0
    sudo umount /mnt/pv1
    sudo umount /mnt/pv2
    sudo umount /mnt/pv3
fi
echo "[COMMON TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[COMMON TASK 9] Set root password"
echo -e "admin123\nadmin123" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[COMMON TASK 10] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.1.100  master.example.com     master
192.168.1.201  worker1.example.com    worker1
192.168.1.202  worker2.example.com    worker2
192.168.1.203  worker3.example.com    worker3
192.168.1.204  worker4.example.com    worker4
192.168.1.205  worker5.example.com    worker5
192.168.1.206  worker6.example.com    worker6
192.168.1.207  worker7.example.com    worker7
192.168.1.208  worker8.example.com    worker8
192.168.1.209  worker9.example.com    worker9
192.168.1.210  worker5.example.com    worker10

192.168.2.201  database1.example.com    database1
192.168.2.202  database2.example.com    database2
192.168.2.203  database3.example.com    database3
192.168.2.204  database4.example.com    database4
192.168.2.205  database5.example.com    database5
EOF
