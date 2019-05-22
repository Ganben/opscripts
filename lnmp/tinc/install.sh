# !/bin/bash
# not runnable
sudo apt install tinc

# add network name
echo >> /etc/networks "\n myvpn 10.20.0.0"

# register port
echo >> /etc/services "tinc            655/tcp    TINC \
tinc            655/udp    TINC"

# create nteword
# source:https://jordancrawford.kiwi/setting-up-tinc/

# network name:
mkdir myvpn
cd myvpn
# conf cloud with 10.0.0.1
echo >> tinc.conf ""


echo >> tinc-up "ifconfig $INTERFACE 10.20.30.1 netmask 255.255.0.0"

echo >> tinc-down "ifconfig $INTERFACE down"

chmod +x tinc-*

# pri-pub key

cd /etc/tinc
mkdir hosts
tincd -c . -K

# place the pubkey to hosts/cloud
sed -i '1s/^/Address = [the hostname or IP address of the cloud server. e.g.: server.mydomain.com]/' hosts/cloud
sed -i '1s/^/Subnet = 10.20.30.1/32/' hosts/cloud
# above: insert first lines into hosts/cloud

# conf home with 10.0.0.2

echo >> tinc.conf "Name = home
AddressFamily = ipv4
Interface = tun0
ConnectTo = cloud"

echo >> tinc-up "ifconfig $INTERFACE 10.20.30.2 netmask 255.255.0.0"

echo >> tinc-down "ifconfig $INTERFACE down"

chmod +x tinc-*

mkdir hosts
tincd -c . -K
# save pubkey to hosts/home
sed -i '1s/^/Subnet = 10.20.30.2/32' hosts/home

# then swap eachothers hosts/* file to tell each other
# mesing: temporary not up

#finally, command
#
# install service
echo >> nets.boot "myvpn"
service tinc start