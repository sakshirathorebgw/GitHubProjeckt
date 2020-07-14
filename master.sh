 #!/bin/bash

 #set -x
 
 #file="/tmp/CCP/auto.properties"
 #$DIR
 #need to export key to supported format for login
 #$SSHKEY_PATH
 #TLS_NAME=
 
 
 
 #to connect to remote test harbor server
 #certificate file name pfx one and location
  CERT_PATH=$(find $DIR -type f -name "*pfx" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
 #Basevalue for the certificate name and key file 
 BASENAME=$(basename $CERT_PATH .pfx)
 TLS_NAME=$BASENAME
 
 echo $TLS_NAME "is new secret name for harbor"
 #certificate password fetchusr/bin/openssl pkcs12 -in
 PASSWORD_FILE=$(find $DIR -type f -name "*txt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
 PASSWORD_VALUE=$(cat $PASSWORD_FILE)
 
 #generate .crt and .key files
#/usr/bin/openssl pkcs12 -in $CERT_PATH -nodes -out $BASENAME.key  -password pass:$PASSWORD_VALUE
#/usr/bin/openssl pkcs12 -in $CERT_PATH -nokeys -out $BASENAME.crt  -password pass:$PASSWORD_VALUE

#KEY_FILE=$(find ./ -type f -name "*key" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
#CRT_FILE=$(find ./ -type f -name "*crt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)

#KEY_FILENAME=$(basename $KEY_FILE)
#CRT_FILENAME=$(basename $CRT_FILE)
#CN_ADDRESS=$(openssl x509 -noout -subject -in test2-harbor.crt | awk '{ print $18 }' | sed 's/.$//' 2>&1)
 
 #scp -i /c/Temp/CCP/harbortestnew $KEY_FILENAME ccpuser@10.32.141.38:/home/ccpuser
 scp -i /c/Temp/CCP/harbortestnew $CERT_PATH ccpuser@10.32.141.38:/home/ccpuser/harbor
 
#CN_ADDRESS=$(openssl x509 -noout -subject -in test2-harbor.crt | awk '{ print $18 }' | sed 's/.$//' 2>&1)
 #       SEARCH1="core: core.harbor.domain"
  #      echo $SEARCH1
   #     REPLACE1="core: $CN_ADDRESS"
    #    echo $REPLACE1

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
     #   SEARCH2="notary: notary.harbor.domain"
      #  echo $SEARCH2
       # REPLACE2="notary: $CN_ADDRESS"
        # echo $REPLACE2

# sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
        #SEARCH3="secretName: "" "
	#	echo $SEARCH3
	#	REPLACE3=secretName: $TLS_NAME
	#	echo $REPLACE3
# sed -i "s/${SEARCH3}/${REPLACE3}/g" values.yaml
 
 #to connect to remote test harbor server
 ssh -i /c/Temp/CCP/harbortestnew ccpuser@10.32.141.38 <<EOF
 
 #cd harbor
 
 #chmod +x test.sh
#ssh ccpuser@10.32.141.38 ccpuser

cd  harbor

/usr/bin/openssl pkcs12 -in $BASENAME.pfx -nodes -out $BASENAME.key  -password pass:$PASSWORD_VALUE
/usr/bin/openssl pkcs12 -in $BASENAME.pfx -nokeys -out $BASENAME.crt  -password pass:$PASSWORD_VALUE

KEY_FILE=$(find ./ -type f -name "*key" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)
CRT_FILE=$(find ./ -type f -name "*crt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1)

KEY_FILENAME=$(basename $KEY_FILE)
CRT_FILENAME=$(basename $CRT_FILE)
CN_ADDRESS=$(openssl x509 -noout -subject -in $CRT_FILENAME | awk '{ print $18 }' | sed 's/.$//' 2>&1)

     
# sed -i "s/${SEARCH3}/${REPLACE3}/g" values.yaml

 helm repo add harbor https://helm.goharbor.io
 helm fetch harbor/harbor --untar
 
 #to create namespace
 kubectl create namespace harbor
 
 #to create secret 
# var1= harbor
 kubectl create secret $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
  SEARCH1="core: core.harbor.domain"
        echo $SEARCH1
        REPLACE1="core: $CN_ADDRESS"
        echo $REPLACE1

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
     SEARCH2="notary: notary.harbor.domain"
        echo $SEARCH2
        REPLACE2="notary: $CN_ADDRESS"
         echo $REPLACE2

 #sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
        SEARCH3="secretName: "" "
               echo $SEARCH3
               REPLACE3=secretName: $TLS_NAME
               echo $REPLACE3

 sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml
 sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml
 #sed -i "s/secretName: ""/${REPLACE3}/g" values1.yaml

sed -i "s/secretName: ""/$REPLACE3/g" values.yaml

#/*AA=$( cat <<\EOF | sed -z -e 's#\([][^$*\.#]\)#\\\1#g' -e 's#\n#\\n#g'
#hosts:
 #     core: core.harbor.domain./
  #    notary: notary.harbor.domain
#EOF
#)

#BB=$( cat <<\EOF | sed -z -e 's#\([&\#]\)#\\\1#g' -e 's#\n#\\n#g'
#hosts:
 #     core: mgmt-registry1.tank.local
  #    notary: mgmt-registry1.tank.local
#EOF
#)*/
#
#sed -z -i 's#'"${AA}"'#'"${BB}"'#g' *.yaml

#install harbor certificate

echo "done"

#helm install harbor . -n harbor


EOF
