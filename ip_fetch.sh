#!/bin/bash

	CCP=10.32.12.180
	export TOKEN=$(curl -v -k -X POST -H "Content-Type:application/x-www-form-urlencoded" -d "username=admin&password=HxMgmt2019!" https://$CCP/v3/system/login 2> >(grep -i x-auth-token) | grep -i x-auth-token | awk -F ":" '{print $2}' | tr -d '\n\r')
	curl -k -X GET -H "X-Auth-Token: $TOKEN" https://$CCP/v3/clusters/ > cluster.txt
	grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' cluster.txt > ip_address.txt
	uniq ip_address.txt ip_add.txt
	sed '/192.168.0.0/d' ip_add.txt > ip.txt
	awk ' /^$/ { print; } /./ { printf("%s ", $0); } ' ip.txt > server1.txt
        rm ip.txt ip_address.txt cluster.txt ip_add.txt

