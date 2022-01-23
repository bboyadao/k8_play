# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "k8s_common.sh"
  config.vm.provision :reload
  WorkerNodes = 2

  # Kubernetes Master Server
  config.vm.define "master" do |node|
    node.vm.box               = "centos/8"
    node.vm.box_check_update  = false
    # node.vm.box_version       = "3.3.0"
    node.vm.hostname          = "master.example.com"

    node.vm.network "public_network", ip: "172.16.16.100",  bridge: "enp6s0"
    node.vm.provider :virtualbox do |v|
      v.name    = "master"
      v.memory  = 2048
      v.cpus    =  2
    end
    node.vm.provision "shell", path: "k8s_master.sh"
  end

# Kubernetes Worker Nodes

  (1..WorkerNodes).each do |i|

    config.vm.define "worker#{i}" do |node|

      node.vm.box               = "centos/8"
      node.vm.box_check_update  = false
      # node.vm.box_version       = "3.3.0"
      node.vm.hostname          = "worker#{i}.example.com"

      node.vm.network "public_network", ip: "172.16.16.10#{i}", bridge: "enp6s0"

      node.vm.provider :virtualbox do |v|
        v.name    = "worker#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end
      node.vm.provision "shell", path: "k8s_worker.sh"

    end

  end

end
