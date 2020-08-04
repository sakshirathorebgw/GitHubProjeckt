  #!/bin/bash

 #set -x

 export KEY_PATH=$KEY_PATH:/c/Temp/CCP
 export CERT_PATH=$CERT_PATH:/c/Temp/CCP/test-harbor-certificate 
 #export DEST_PATH: $DEST_PATH:/home/ccpuser/harbor
 
 #to connect to remote test harbor server
 
  
scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor-certificate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser/harbor


