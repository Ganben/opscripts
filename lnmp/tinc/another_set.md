Tinc setup instructions for Ubuntu and Windows. Based on [1](https://nwgat.ninja/quick-easy-tinc-1-1-2/) [2](https://nwgat.ninja/simplified-tinc-1-1-on-windows-10/).
====

### Start here.
1. `sudo apt-get install -y build-essential libncurses5-dev libreadline6-dev libzlcore-dev zlib1g-dev liblzo2-dev libssl-dev`
2. Download and install tinc  
  2.1. Download the latest tinc 1.1 source package ( current: `wget https://www.tinc-vpn.org/packages/tinc-1.1pre16.tar.gz -O tinc.tar.gz`)  
    * `tar -xf tinc.tar.gz --one-top-level --strip-components=1`
    * `cd tinc`
    * `./configure`
    *  `make`
    * `sudo make install`  
  2.2. On Windows - https://www.tinc-vpn.org/packages/windows/tinc-1.1pre16-install.exe. Make sure to install install everything it offers.

Now go to the section that corresponds to your platform.

### On Linux machines:
1. Enable udp port 655. This is recommended for all the clients, and is required for the server.  
  1.1. If you use ufw: `ufw allow 655`  
  1.2. If you use iptables: `iptables -I INPUT -p udp --dport 655 -m state --state NEW -j ACCEPT`.  
2. Install tinc service  
  2.1. systemd:  
    * Create and copy the following to `/lib/systemd/system/tinc.service`
    
```
[Unit]
Description=Tinc VPN
After=network.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/bin/true
ExecReload=/bin/true
WorkingDirectory=/usr/local/etc/tinc

[Install]
WantedBy=multi-user.target
```

   * Create and copy the following to `/lib/systemd/system/tinc@.service`

```
[Unit]
Description=Tinc net %i
PartOf=tinc.service
ReloadPropagatedFrom=tinc.service

[Service]
Type=simple
WorkingDirectory=/usr/local/etc/tinc/%i
ExecStart=/usr/local/sbin/tincd -n %i -D
ExecReload=/usr/local/sbin/tincd -n %i -kHUP
KillMode=mixed
TimeoutStopSec=5
Restart=always
RestartSec=60

[Install]
WantedBy=tinc.service
```

   * `systemctl unmask tinc`  
3. `sudo mkdir -p /usr/local/var/run/`

If this is the first machine in the network, go to the "On the server" section. Otherwise, go to the clients section below it.

##### On the server
Technically there is no real distinction between the two with tincd. Think of this as the first machine that will get your network going.

1. `sudo tinc -n VPNNAME init server` (replace VPNNAME here and in the following commands with the name you want).
2. `sudo tincd -n VPNNAME`.
3. `sudo tinc -n VPNNAME add subnet IP` (replace IP here and in the following commands with the ip you want for this device, i.e. 10.0.0.1).
4. To add a new client to the network you need to run `sudo tinc -n VPNNAME invite CLIENTNAME`. It will ask you for your publically accessable hostname and will generate an URL that you will need to connect your clients to the network.

##### On the clients:

1. `sudo tinc join INVITEURL`. To get an invite URL, see the server section.
2. `sudo tincd -n VPNNAME` where VPNNAME is the name of your network.
3. `sudo tinc -n VPNNAME add subnet IP` where IP is the IP of this node. (You might not need to do this because it can auto-assign an IP it seems).

##### After client/server setup

1. Copy the following to `/usr/local/etc/tinc/VPNNAME/tinc-up`. Replace IP with the address you want for this device.
```
#!/bin/bash
ip addr add IP/24 dev $INTERFACE
ip link set $INTERFACE up
```
2. Create and copy the following to `/usr/local/etc/tinc/VPNNAME/tinc-down`. Replace IP with the address you want for this device.
```
#!/bin/bash
ip route del IP/24 dev $INTERFACE
ifconfig $INTERFACE down
```
3. `chmod +x /usr/local/etc/tinc/VPNNAME/tinc-down /usr/local/etc/tinc/VPNNAME/tinc-up`  
3.1. If you want to push your own DNS servers, you'll also need to add `echo -n "nameserver DNSSERVER" | /sbin/resolvconf -a "$INTERFACE"` to `tinc-up` (where DNSSERVER is your nameserver's IP address), and `/sbin/resolvconf -d "$INTERFACE"` to `tinc-down`.  
4. Start tinc. You obviously want to start the server's daemon first.  
  4.1. To start the daemon in debug mode, you can use the following command - `sudo tincd -n VPNNAME -D -d3`. You will need to stop any previously running daemons though (`killall tincd`). You will probably want to do this while connecting your first client to see if it connects okay.  
  4.2. To start the daemon as a service  
    * On systemd: `systemctl start tinc@VPNNAME`.
5. To start the daemon on system startup.  
  5.1. On systemd: `systemctl enable tinc@VPNNAME`.

### On Windows machines

Note that you need to do all of this in an elevated command prompt (or an elevated powershell).

1. `cd "C:\Program Files\tinc\tap-win64"`
2. `addtap.bat`
3. Locate the network adapter that was just created.  
  3.1. `netsh interface ipv4 show interfaces`  
  3.2. `control netconnections`  
4. `netsh interface set interface name = "CREATEDINTERFACE" newname = "tinc"` where CREATEDINTERFACE is the name of the interface that was created (i.e. `Ethernet 2`).
5. `netsh interface ip set address "tinc" static VPNIP 255.255.255.0` (replace IP here and in the following commands with the ip you want for this device, i.e. 10.0.0.1).  
5.1. Optionally, if you want to set DNS servers - `netsh interface ipv4 add dnsserver "tinc" address=DNSSERVER index=1`.
6. `cd "C:\Program Files\tinc"`

Proceed with the instructions for either the server (first node), or clients.

##### On the server

Note that if you're using powershell, you need to prepend the commands with `./`.

1. `tinc -n VPNNAME init master` where VPNNAME is the name of the network you want.
2. `tinc -n VPNNAME add subnet IP`
3. `tinc -n VPNNAME add address=FQDNORIP` where FQDNORIP is the publically accessable hostname or the IP address of your device.
4. To create invitations for clients, run `tinc -n VPNNAME invite CLIENTNAME`.

##### On clients.

1. `tinc join INVITEURL` where INVITEURL is the url generated by the server.
2. `tinc -n VPNNAME add subnet IP` where VPNNAME is the name of the network you want.

##### After client/server setup

1. To run the daemon  
1.1. To start the daemon in debug mode `tincd -n VPNNAME -D -d3`. 
2. To create a tinc service, run `tincd -n VPNNAME`.  
2.1. Then you can open the services panel (`services.msc`) to start, stop and enable start on boot  
2.2. You can also use the command line to manage it. I.e. `sc config tinc.VPNNAME start=auto` to enable start on boot, `net start tinc.VPNNAME` to start the service.

##### Android

For users without root. In this mode the tinc app will only work in `router` mode - 

1. Generate an invite link on your server
2. Download http://tincapp.pacien.org/
3. Open the app, click the wrench icon at top right corner. Click 'join network via invitation URL. Type down the URL.
4. In the same menu, take note of the configuration directory (default - `/Android/data/org/pacien.tincapp/files`. You can hold and copy+paste it if you want to, even if there's no feedback for the hold gesture ). Open it. There you'll find a directory with your VPNNAME. Open it. There should be an empty file called 'network.conf'. Edit it and add the following -

```
Address=IP/32
Route=NETWORKADDRESS/24
```

IP is your device's IP. NETWORKADDRESS is the network address for your IP range (with /24, it's probably the IP with the last number being 0, i.e. `10.0.0.0/24`).  
4.1. Optionally, you can also add a DNS server -`DNSServer=IP`, although note that these DNSServer entries will override your default connection's settings, so if your DNS server isn't set to resolve queries for the whole internet (meaning private network only), you probably want to add another `DNSServer` line with a public DNS resolver right after the previous, i.e.
```
DNSServer=IP
DNSServer=8.8.8.8
```

5. Now in the same directory, go into the `hosts` folder and edit the file that has your device's name. Add `Subnet=IP` at the bottom.
5.1. This file should contain your public key, and below it there should be a `Port` variable. You don't have to change it, but if you want to, you can set it to 0 for random port on each connection.