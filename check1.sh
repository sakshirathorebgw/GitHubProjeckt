#!/bin/bash
source server.txt
source server1.txt

NAMESPACE_OUTPUT=$(kubectl get namespace | grep harbor | awk '{ print $1 }')
echo "namespace is $NAMESPACE_OUTPUT"
if [ -z "$NAMESPACE_OUTPUT" ]

then
      echo  " "$NAMESPACE_OUTPUT" is NULL"
      for server in $(cat server.txt) ; do ssh ccpuser@${server} /bin/bash <<EOF
	chmod +x new_server_cert.sh 
'bash -s' < ./new_server_cert.sh ; 
EOF
done
	  #chmod +x new_server_cert.sh
    #./new_server_cert.sh
     for server in $(cat server1.txt) ; do ssh ccpuser@${server} /bin/bash <<EOF
chmod +x cert_update.sh
'bash -s' < ./cert_update.sh ;
EOF
done

#	    chmod +x cert_update.sh
#	    ./cert_update.sh
else
     echo " "$NAMESPACE_OUTPUT" is NOT NULL"
      for server in $(cat server.txt) ; do ssh ccpuser@${server} /bin/bash <<EOF
	 chmod +x cert_status1.sh
    'bash -s' < ./cert_status1.sh ;
EOF
done
fi
