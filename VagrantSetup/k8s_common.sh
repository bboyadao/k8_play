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

echo "[COMMON TASK 4] Enable containerd"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

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
echo '''echo 'Environment="KUBELET_EXTRA_ARGS=--node-ip=${DROPLET_IP_ADDRESS}" '''' >> /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
echo "[COMMON TASK 8] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[COMMON TASK 9] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[COMMON TASK 10] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.1.100  master.example.com     master
192.168.1.201  worker1.example.com    worker1
192.168.1.202  worker2.example.com    worker2
192.168.1.203  worker3.example.com    worker3
192.168.1.204  worker4.example.com    worker4
192.168.1.205  worker5.example.com    worker5
EOF
