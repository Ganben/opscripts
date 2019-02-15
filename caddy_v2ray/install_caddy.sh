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

# v2ray configs
# TODO