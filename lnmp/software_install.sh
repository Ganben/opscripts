
# 

# HTTPS cert
# ubuntu 1710
# github.com/wangyan/lanmp/blob/master/deb.sh

sudo apt install software-properties-common -y
sudo add-apt-repository ppa:certbot/certbot

sudo apt update
sudo apt install python-certbot-nginx -y

/usr/local/mysql/bin/mysqladmin -u root password $MYSQL_ROOT_PWD  #Default=123456
