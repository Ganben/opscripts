# Graphite

install, usage is easy
but document, config is so complex

## install

- docker:

```
docker run -d\
 --name graphite\
 --restart=always\
 -p 80:80\
 -p 2003-2004:2003-2004\
 -p 2023-2024:2023-2024\
 -p 8125:8125/udp\
 -p 8126:8126\
 graphiteapp/graphite-statsd
```

## basic UDP to stats

```
import socket

address = ('127.0.0.1', 8125) #to server inet addr
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

while True:
    msg = raw_input()

    # example:60|c
    if not msg:
        break
    s.sendto(msg, address)

s.close()
```

## config settings

