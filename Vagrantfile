# -*- mode: ruby -*-
# vi: set ft=ruby :

# ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  NodeCount = 2
  Type = "worker"

  (1..NodeCount).each do |i|
    config.vm.define "#{Type}#{i}" do |node|
      node.vm.box = "centos/8"
      node.vm.hostname = "#{Type}#{i}.chuthe.com"
      node.vm.network "private_network",
        ip:"192.168.56.1#{i}",
        auto_config: false
      node.vm.provider "virtualbox" do |v|
        v.name = "#{Type}#{i}"
        v.memory = 2048
        v.cpus = 1
      end
    end
  end

end
