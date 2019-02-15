curl https://getcaddy.com | bash -s personal
# do no if start this with bash/shell command

# write a file with following lines to /etc/Caddyfile
# v2ray.example.com
# {
#   log /var/log/caddy.log
#   proxy /ray localhost:10000 {
#     websocket
#     header_upstream -Origin
#   }
# }

caddy -conf /etc/Caddyfile

# caddy as systemd
sudo setcap cap_net_bind_service=+ep ./caddy

# /etc/systemd/system/caddy.service
[Unit]
Description=Caddy webserver
Documentation=https://caddyserver.com/
After=network.target

[Service]
User=ccao
#Group=some_group
WorkingDirectory=/home/ccao/web/
LimitNOFILE=4096
PIDFile=/var/run/caddy/caddy.pid
ExecStart=caddy -conf /etc/Caddyfile -pidfile=/var/run/caddy/caddy.pid
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target

# v2ray configs
# TODO