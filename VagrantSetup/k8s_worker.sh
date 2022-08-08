cd /vagrant/open_sources/
tar -xvf sshpass-1.08.tar.gz >/dev/null 2>&1
cd sshpass-1.08
./configure >/dev/null 2>&1
make && make install >/dev/null 2>&1

echo "[TASK 1] JOIN NODE"
/usr/local/bin/sshpass -p "admin123" scp -o PreferredAuthentications="password" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.example.com:/joincluster.sh /joincluster.sh
bash /joincluster.sh
