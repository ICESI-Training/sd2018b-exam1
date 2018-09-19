#!/usr/bin/env bash
yum install dhcp -y
yum install wget -y
wget https://raw.githubusercontent.com/rubendcm9708/sd-workshop0/rceballos/sd-workshop0/A00054636/activity2/DHCP_Server/templates/dhcpd.conf -O /etc/dhcp/dhcpd.conf
systemctl start dhcpd

