#!/bin/bash
echo "[MASTER TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[MASTER TASK 2] Initialize Kubernetes Cluster"
# kubeadm init --apiserver-advertise-address=192.168.0.100 --pod-network-cidr=192.168.56.0/16 >> $HOME/kubeinit.log 2>/dev/null
kubeadm init --apiserver-advertise-address=192.168.1.100 --pod-network-cidr=10.244.0.0/16 >> $HOME/kubeinit.log 2>/dev/null

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "[MASTER TASK 3] Deploy Calico network"
kubectl create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml >/dev/null 2>&1

echo "[MASTER TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

