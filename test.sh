 #!/bin/bash
#cd harobr
#cp /home/ccpuser/test2-harbor.pfx .
 /usr/bin/openssl pkcs12 -in test2-harbor.pfx -nodes -out test2-harbor.key -password pass:start01
/usr/bin/openssl pkcs12 -in test2-harbor.pfx -nokeys -out test2-harbor.crt -password pass:start01
 
# helm repo add harbor https://helm.goharbor.io
#helm fetch harbor/harbor --untar
 
 #to create namespace
 #kubectl create namespace harbor
 
#to create secret 
# var1= harbor
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

helm install harbor . -n harbor
