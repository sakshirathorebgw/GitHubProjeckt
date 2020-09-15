#!/bin/bash
NAMESPACE_OUTPUT=$(kubectl get namespace | grep harbor | awk '{ print $1 }')
echo "namespace is $NAMESPACE_OUTPUT"
if [ -z "$NAMESPACE_OUTPUT" ]

then
     echo  " "$NAMESPACE_OUTPUT" is NULL"
	  chmod +x new_server_cert.sh
 #   ./new_server_cert.sh
else
     echo " "$NAMESPACE_OUTPUT" is NOT NULL"
	 chmod +x cert_status1.sh
    ./cert_status1.sh
fi
