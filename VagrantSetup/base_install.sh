# Install LXD
echo "Install LXD"
sudo dnf update -y
sudo dnf install -y vim curl
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf update
sudo yum install snapd -y
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

sudo grubby --args="user_namespace.enable=1" --update-kernel="$(grubby --default-kernel)"
sudo grubby --args="namespace.unpriv_enable=1" --update-kernel="$(grubby --default-kVVernel)"
sudo echo "user.max_user_namespaces=3883" | sudo tee -a /etc/sysctl.d/99-userns.conf
