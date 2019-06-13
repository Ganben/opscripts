# !/bin/bash
# not runnable

sudo apt update
sudo apt install default-jdk

# https://kafka.apache.org/downloads
#
sudo apt install zookeeperd
#
cd ~
mkdir kafka

#
curl "https://www.apache.org/dist/kafka/2.2.0/kafka_2.12-2.2.0.tgz" -o ~/kafka/kafka.tgz
tar -xvzf kafka/kafka.tgz --strip 1

# server.properties:
#listeners=PLAINTEXT://\
#ec2-XXX-XXX-XXX-XXX.eu-central-1.compute.amazonaws.com:9092
# to local address:9092
#
sudo cp -r kafka/kafka /opt/kafka
sudo /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties

# running on localhost:9092 by default or inet
#