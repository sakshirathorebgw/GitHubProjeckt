 #!/bin/bash

 #set -x
 
 #file="/tmp/CCP/auto.properties"
 
  export KEY_PATH=$KEY_PATH:/c/Temp/CCP
 export CERT_PATH=$CERT_PATH:/c/Temp/CCP/test-harbor-certificate
 #export DEST_PATH: $DEST_PATH:/home/ccpuser/harbor
 #HOST_NAME=10.32.141.38
 USER_NAME=ccpuser
 #export HOST_NAME= $HOST_NAME
 export USER_NAME= $USER_NAME
 
 #to connect to remote test harbor server
 
 #scp -i $KEY_PATH $CERT_PATH ccpuser@10.32.141.38 :/home/ccpuser/harbor
 scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor_Testzertifikate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser/harbor

 #to connect to remote test harbor server
 ssh -i /c/Temp/CCP/harbortestnew ccpuser@10.32.141.38 << EOF


cd harbor
ls
#chmod +x test.sh
#./test.sh
openssl pkcs12 -in test2-harbor.pfx -nodes -out test2-harbor.key -password pass:start01
openssl pkcs12 -in test2-harbor.pfx -nokeys -out test2-harbor.crt -password pass:start01
 
helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar
 
 #to create namespace
 kubectl create namespace harbor
 
 #to create secret 
 
kubectl create secret tls harbor --key test2-harbor.key --cert test2-harbor.crt --namespace harbor 

sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml

AA=$( cat <<\EOF | sed -z -e 's#\([][^$*\.#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: core.harbor.domain./
      notary: notary.harbor.domain
EOF
)

BB=$( cat <<\EOF | sed -z -e 's#\([&\#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: mgmt-registry1.tank.local
      notary: mgmt-registry1.tank.local
EOF
)

sed -z -i 's#'"${AA}"'#'"${BB}"'#g' *.yaml

#install harbor certificate

#helm install harbor . -n harbor

EOF



