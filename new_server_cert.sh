#!/bin/bash

#helm repo add harbor https://helm.goharbor.io
#helm fetch harbor/harbor --untar

#to create namespace
#kubectl create namespace harbor
#var1=$(pwd)

#cd /usr/local/share/ca-certificates/
#sudo cp $var1/*.pfx .
#sudo cp $var1/*.crt .
#sudo cp $var1/*.key .

#sudo chmod -R 644 /usr/local/share/ca-certificates/
#sudo update-ca-certificates

cd 

helm repo add harbor https://helm.goharbor.io
helm fetch harbor/harbor --untar


cd harbor
#to create secret 
# var1= harbor
cp ../*.pfx .
cp ../*.crt .
cp ../*.key .
ls -lrt
 #to create namespace
kubectl create namespace harbor

# kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
 
 CERT_PATH=$(find ./ -type f -name "*pfx" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
 export CERT_PATH=$CERT_PATH
 echo $CERT_PATH "is certpath"
  BASENAME=$(basename $CERT_PATH .pfx)
  export BASENAME=$BASENAME
  echo $BASENAME "is basename"
  TLS_NAME=$BASENAME
   echo $TLS_NAME "is new secret name for harbor"

KEY_FILE=$(find ./ -type f -name "*key" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
                export KEY_FILE=$KEY_FILE
                        echo $KEY_FILE "key file generated"
CRT_FILE=$(find ./ -type f -name "*crt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
                export CRT_FILE=$CRT_FILE
                        echo $CRT_FILE "crt file generated"
# to get name for the key and crt file
KEY_FILENAME=$(basename $KEY_FILE)
echo "key filename is" $KEY_FILENAME
CRT_FILENAME=$(basename $CRT_FILE)
echo "crt filename is" $CRT_FILENAME


 CN_ADDRESS=$(openssl x509 -noout -subject -in $CRT_FILENAME | awk '{ print $18 }' | sed 's/.$//' 2>&1)
      #  SEARCH1="core: core.harbor.domain"
      #  echo $SEARCH1
        REPLACE1="core: $CN_ADDRESS"
        echo $REPLACE1
 sed -i "0,/ core: /{s/ core:.*/ ${REPLACE1}/}" values.yaml

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
      # SEARCH2="notary: notary.harbor.domain"
      # echo $SEARCH2
        REPLACE2="notary: $CN_ADDRESS"
         echo $REPLACE2
 sed -i "0,/ notary: /{s/ notary:.*/ ${REPLACE2}/}" values.yaml

# sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
       # SEARCH3="secretName: """
	#	echo $SEARCH3
		REPLACE3="secretName: $TLS_NAME"
		echo $REPLACE3
 sed -i "s/secretName:.*/${REPLACE3}/g" values.yaml

# sed -i "s/${SEARCH3}/${REPLACE3}/g" values.yaml
 
 
 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values1.yaml
 #sed -i "s/${SEARCH2}/${REPLACE2}/g" values1.yaml
 #sed -i "s/${SEARCH3}/${REPLACE3}/g" values1.yaml
 
 #sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml
 echo $KEY_FILE
 echo $CRT_FILE
 kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor

 helm install harbor . -n harbor
 #helm upgrade harbor -n harbor 
 echo "Harbor certificate isntallation done"
 
