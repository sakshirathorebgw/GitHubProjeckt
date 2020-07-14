#!/bin/bash

 #set -x

 #file="/tmp/CCP/auto.properties"


 #to connect to remote test harbor server

 scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor_Testzertifikate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser/harbor
 #scp -i /c/Temp/CCP/harbortestnew /c/Temp/CCP/test-harbor_Testzertifikate/test2-harbor.pfx ccpuser@10.32.141.38:/home/ccpuser

 #to connect to remote test harbor server
 ssh -i /c/Temp/CCP/harbortestnew ccpuser@10.32.141.38 << EOF 
 
 
helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar

#to create namespace
 kubectl create namespace harbor

ls

# cd harbor
 
#cp /home/ccpuser/test2-harbor.pfx .

 /usr/bin/openssl pkcs12 -in test2-harbor.pfx -nodes -out test2-harbor.key -password pass:start01
/usr/bin/openssl pkcs12 -in test2-harbor.pfx -nokeys -out test2-harbor.crt -password pass:start01



 #to create secret
kubectl create secret tls harbor --key test2-harbor.key --cert test2-harbor.crt --namespace harbor

sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml

AA=$( sed -z -e 's#\([][^$*\.#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: core.harbor.domain./
      notary: notary.harbor.domain
)

BB=$( sed -z -e 's#\([&\#]\)#\\\1#g' -e 's#\n#\\n#g'
hosts:
      core: mgmt-registry1.tank.local
      notary: mgmt-registry1.tank.local
)

sed -z -i 's#'"${AA}"'#'"${BB}"'#g' *.yaml

#install harbor certificate

helm install harbor . -n harbor

EOF

