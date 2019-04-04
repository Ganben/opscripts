# !/bin/bash

sudo echo "Match group sftp
ChrootDirectory /home
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp" >> /etc/ssh/sshd_config

sudo service ssh restart

sudo addgroup sftp
sudo useradd -m sftpuser -g sftp

sudo passwd sftpuser

# sudo chmod 700 /home/sftpuser #optional