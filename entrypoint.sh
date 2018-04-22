#!/bin/sh

set -e
set -x

IP_LEFT_EXT="$(hostname -i)"
IP_RIGHT_EXT="${IP_RIGHT_EXT:-any}"

IP_LEFT_INT="${IP_LEFT_INT:-172.16.0.255}"
IP_RIGHT_INT="${IP_RIGHT_INT:-172.16.0.0}"

/sbin/ip tun add ipip0 mode ipip local "${IP_LEFT_EXT}" remote "${IP_RIGHT_EXT}"
/sbin/ip addr add "${IP_LEFT_INT}/32" peer "${IP_RIGHT_INT}" dev ipip0
/sbin/ip link set dev ipip0 up

/sbin/ip route add default via "${IP_RIGHT_INT}" dev ipip0 table 100
/sbin/ip rule add from "${IP_LEFT_INT}" table 100
/sbin/ip rule add iif eth0 fwmark 0xff000000/0xffffffff table 100

/usr/sbin/ferm /etc/ferm.conf
/sbin/sysctl -qw net.ipv4.ip_forward=1

while :; do sleep 1d; done
