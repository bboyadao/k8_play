cd /vagrant/open_sources/
tar -xvf sshpass-1.08.tar.gz
cd sshpass-1.08
./configure
make && make install

echo "[TASK 1] JOIN NODE"
/usr/local/bin/sshpass -p "admin123" scp -o PreferredAuthentications="password" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.example.com:/joincluster.sh /joincluster.sh
bash /joincluster.sh
