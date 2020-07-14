#!/bin/bash

 #set -x

 file="/tmp/CCP/auto.properties"


 #to connect to remote test harbor server

 scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor_Testzertifikate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser/harbor
scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test.sh ccpuser@10.32.141.38:/home/ccpuser/harbor

CN_ADDRESS=$(openssl x509 -noout -subject -in test2-harbor.crt | awk '{ print $18 }' | sed 's/.$//' 2>&1)
        SEARCH1="core: core.harbor.domain"
        echo $SEARCH1
        REPLACE1="core: $CN_ADDRESS"
        echo $REPLACE1

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
        SEARCH2="notary: notary.harbor.domain"
	echo $SEARCH2
        REPLACE2="notary: $CN_ADDRESS"
	 echo $REPLACE2

#                        sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml


 #to connect to remote test harbor server
 ssh -i /c/Temp/CCP/harbortestnew ccpuser@10.32.141.38 <<EOF


 cd harbor
# chmod +x ./test.sh
# ./test.sh
ls

EOF
