# !/bin/bash
# must installed docker

sudo docker create iroha-network

sudo docker run --name some-postgres \
-e POSTGRES_USER=postgres \
-e POSTGRES_PASSWORD=mysecretpassword \
-p 5432:5432 \
--network=iroha-network \
-d postgres:9.5

sudo docker volume create blockstore

git clone -b master https://github.com/hyperledger/iroha --depth=1

sudo docker run -it --name iroha \
-p 50051:50051 \
-v $(pwd)/iroha/example:/opt/iroha_data \
-v blockstore:/tmp/block_store \
--network=iroha-network \
--entrypoint=/bin/bash \
hyperledger/iroha:latest


# this goes in docker console
# attach from outside:
# sudo docker exec -it iroha /bin/bash
#(docker) iroha-cli -account_name admin@test
# test on ubuntu 16.04 xenial pass
