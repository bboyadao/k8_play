- Let create virtual machine named: "CentOS" `vagrant package --base=CentOS --output=centos64.box
`
- Then attach to vag `vagrant box add centos64.box --name=centos64`
- so we can use as: 
```
Vagrant.configure(VERSION) do |config|
  config.vm.box = "centos64"
end
```