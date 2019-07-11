# !/bin/bash

apt install daemontools

mkdir -p /service/${myapp} /var/log/${myapp}
vim /service/${myapp}/run
# run scipt
# env vars
. ${envscript}
exec python3 ${myscript} --dev start >> log 2>&1

# outside the file
supervise /service/${myapp} &