#!/bin/bash
IPTABLES=/sbin/iptables
$IPTABLES -F
$IPTABLES -X
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -P FORWARD DROP
$IPTABLES -A INPUT  -p tcp --dport 6066 -j ACCEPT
$IPTABLES -A INPUT  -s 127.0.0.1 -j ACCEPT
$IPTABLES -A INPUT  -p icmp -j ACCEPT
$IPTABLES -A INPUT  -p tcp --dport 21 -j ACCEPT
$IPTABLES -A INPUT  -p tcp --dport 80 -j ACCEPT
$IPTABLES -A INPUT  -p tcp --dport 443 -j ACCEPT
$IPTABLES -A INPUT  -p tcp --dport 10050 -j ACCEPT
$IPTABLES -A INPUT  -p udp --dport 53 -j ACCEPT
$IPTABLES -A INPUT  -m state --state ESTABLISHED,RELATED -j ACCEPT