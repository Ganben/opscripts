# !/bin/bash

sudo apt install tinc

# add network name
echo >> /etc/networks "\n myvpn 10.0.0.0"

# register port
echo >> /etc/services "tinc            655/tcp    TINC \
tinc            655/udp    TINC"

