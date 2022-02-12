# yum install -qq -y sshpass >/dev/null 2>&1
yum install -qq -y sshpass
# wget https://archives.fedoraproject.org/pub/archive/epel/6/x86_64/epel-release-6-8.noarch.rpm . >/dev/null 2>&1
# rpm -ivh epel-release-6-8.noarch.rpm >/dev/null 2>&1
# yum --enablerepo=epel -y install sshpass  >/dev/null 2>&1
# rm epel-release-6-8.noarch.rpm >/dev/null 2>&1
echo "[TASK 1] JOIN NODE"
# sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.example.com:/joincluster.sh /joincluster.sh 2>/dev/null
# bash /joincluster.sh >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.example.com:/joincluster.sh /joincluster.sh
bash /joincluster.sh
