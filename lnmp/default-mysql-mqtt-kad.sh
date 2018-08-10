
# to install: bin/bash/
# pip3 install kademlia
port = 9900
# apt install mosquitto
# vi /etc/mosquitto/conf.d/default.conf
bind_address 0.0.0.0
listener 9883
protocol websockets
systemctl restart mosquitto.service

# 