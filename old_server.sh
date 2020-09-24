#!/bin/bash

 
#to create secret 
# var1= harbor
#kubectl delete namespace harbor
#helm repo add harbor https://helm.goharbor.io

#helm fetch harbor/harbor --untar
#rm -rf harbor
#mv "/home/ccpuser/harbor "* "/home/ccpuser/Harbor_Backup `date '+%b-%d-%Y'`
#mv /home/ccpuser/harbor /home/ccpuser/harbor_`date '+%b-%d-%Y-%H-%M-%S'`

#unzip -o harbor.zip
cd harbor
		cp ../*.pfx .
		cp ../*.crt .
		cp ../*.key .
		cp ../ca.crt .
	
		ls -lrt
#kubectl create namespace harbor

: '
 CERT_PATH=$(find $DIR -type f -name "*pfx" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
 export CERT_PATH=$CERT_PATH
 echo $CERT_PATH "first is certpath"
  BASENAME=$(basename $CERT_PATH .pfx)
  export BASENAME=$BASENAME
  echo $BASENAME "is basename"
  TLS_NAME=$BASENAME
   echo $TLS_NAME "is new secret name for harbor"

  #certificate password fetch
  PASSWORD_FILE=$(find $DIR -type f -name "readme.txt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
  PASSWORD_VALUE=$(cat $PASSWORD_FILE)
  export PASSWORD_VALUE=$PASSWORD_VALUE
  echo "this is password " $PASSWORD_VALUE

   #generate .crt and .key files
/usr/bin/openssl pkcs12 -in $CERT_PATH -nodes -out $BASENAME.key  -password pass:$PASSWORD_VALUE
/usr/bin/openssl pkcs12 -in $CERT_PATH -nokeys -out $BASENAME.crt  -password pass:$PASSWORD_VALUE

# to get key and crt file path
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
echo "address for certificate is :" $CN_ADDRESS
'


CERT_PATH=$(find ./ -type f -name "*pfx" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
 export CERT_PATH=$CERT_PATH
 echo $CERT_PATH "is certpath"
  BASENAME=$(basename $CERT_PATH .pfx)
  export BASENAME=$BASENAME
  echo $BASENAME "is basename"
  TLS_NAME=$BASENAME
   echo $TLS_NAME "is new secret name for harbor"

KEY_FILE=$(find ./ -type f -name $TLS_NAME.key -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
                export KEY_FILE=$KEY_FILE
                        echo $KEY_FILE "key file generated"
CRT_FILE=$(find ./ -type f -name $TLS_NAME.crt -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
                export CRT_FILE=$CRT_FILE
                        echo $CRT_FILE "crt file generated"
# to get name for the key and crt file
KEY_FILENAME=$(basename $KEY_FILE)
echo "key filename is" $KEY_FILENAME
CRT_FILENAME=$(basename $CRT_FILE)
echo "crt filename is" $CRT_FILENAME

#kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
#CN_ADDRESS=$(openssl x509 -noout -subject -in test2-harbor.crt | awk '{ print $18 }' | sed 's/.$//' 2>&1)
        #SEARCH1="core: core.harbor.domain"
       # echo $SEARCH1
      #  REPLACE1="core: $CN_ADDRESS"
     #   echo $REPLACE1

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
        #SEARCH2="notary: notary.harbor.domain"
    #    echo $SEARCH2
   #     REPLACE2="notary: $CN_ADDRESS"
  #       echo $REPLACE2

# sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
 #       SEARCH3="secretName: """
#		echo $SEARCH3
#		REPLACE3="secretName: $TLS_NAME"
#		echo $REPLACE3
# sed -i "s/${SEARCH3}/${REPLACE3}/g" values.yaml
 
 
 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values1.yaml
 #sed -i "s/${SEARCH2}/${REPLACE2}/g" values1.yaml
 #sed -i "s/${SEARCH3}/${REPLACE3}/g" values1.yaml
 
 #sed -i 's/secretName: ""/secretName: "Harbor"/g' values.yaml

  CN_ADDRESS=$(openssl x509 -noout -subject -in $CRT_FILENAME | awk '{ print $18 }' | sed 's/.$//' 2>&1)
        SEARCH1="core: mgmt-registry.tank.local"
      #  echo $SEARCH1
        REPLACE1="core: $CN_ADDRESS"
        echo $REPLACE1
 sed -i "0,/ core: /{s/ core:.*/ ${REPLACE1}/}" values.yaml

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
       SEARCH2="notary: mgmt-registry.tank.local"
      # echo $SEARCH2
        REPLACE2="notary: $CN_ADDRESS"
         echo $REPLACE2
 sed -i "0,/ notary: /{s/ notary:.*/ ${REPLACE2}/}" values.yaml

# sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
        SEARCH3="secretName: "tank""
        #       echo $SEARCH3
                REPLACE3="secretName: $TLS_NAME"
                echo $REPLACE3
 #sed -i "s/secretName:tank/${REPLACE3}/g" values.yaml
  sed -i "s/secretName:.*/${REPLACE3}/g" values.yaml

 echo "values.yaml is updated"

 #output=$(kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor)
 #echo $output
 #cat root_ca.crt |base64 | tr -d "\n"

 cat ca.crt |base64 | tr -d "\n" > ca.crt.txt
 sed -i '1s/^/  ca.crt: /' ca.crt.txt
 sed -i 's/$/\n/' ca.crt.txt
 kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
 kubectl get secret $TLS_NAME -n harbor -o yaml > ca.crt.yaml

 #sed -i '/data:/r ca.crt.txt' ca.crt.yaml
 awk 'FNR==3{system("cat ca.crt.txt")} 1' ca.crt.yaml > ca.crt_final.yaml

 #kubectl apply -f ca.crt.yaml

# helm install harbor . -n harbor
helm upgrade harbor . -n harbor 
 echo "Harbor certificate upgrade  done"
 kubectl apply -f ca.crt_final.yaml

 rm ca.crt
