#!/bin/bash

 
#to create secret 
# var1= harbor

cp ../*.crt .
cp ../*.key .
ls
 kubectl create secret $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
 
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

# sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
        SEARCH3="secretName: """
		echo $SEARCH3
		REPLACE3="secretName: $TLS_NAME"
		echo $REPLACE3
# sed -i "s/${SEARCH3}/${REPLACE3}/g" values.yaml
 
 
 sed -i "s/${SEARCH1}/${REPLACE1}/g" values1.yaml
 sed -i "s/${SEARCH2}/${REPLACE2}/g" values1.yaml
 #sed -i "s/${SEARCH3}/${REPLACE3}/g" values1.yaml
 
 sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml
 helm install harbor . -n harbor
 
 echo "Harbor certificate isntallation done"
