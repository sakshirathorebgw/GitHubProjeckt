#!/bin/bash

 #set -x

 file="/tmp/CCP/auto.properties"


 #to connect to remote test harbor server

scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor_Testzertifikate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser/harbor
scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test.sh ccpuser@10.32.141.38:/home/ccpuser/harbor
 #to connect to remote test harbor server
 sshpass -f  /c/Temp/CCP/harbortestnew /usr/bin/ssh ccpuser@10.32.141.38 /bin/bash << EOF


 cd harbor
ls
#chmod +x test.sh
#./test.sh

EOF

