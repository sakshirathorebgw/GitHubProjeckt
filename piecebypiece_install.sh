#!/bin/bash

#ssh key path set
#SSHKEY_PATH=/c/Users/D35N/Downloads/GitHubProjeckt/Automation/GitHubProjeckt/newharbortestkey

# export SSHKEY_PATH=$SSHKEY_PATH
# echo "path for ssh key is" $SSHKEY_PATH
source inputfile.txt
source server.txt
 #export SSHKEY_PATH=$SSHKEY_PATH
 #echo "path for ssh key is" $SSHKEY_PATH


#certificate file name pfx one and location
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
#declare variable for substitutions in values.yaml
		SEARCH1="core: mgmt-registry.tank.local"
		export SEARCH1=$SEARCH1
			echo $SEARCH1
        REPLACE1="core: $CN_ADDRESS"
		export REPLACE1=$REPLACE1
			echo $REPLACE1

 #sed -i "s/${SEARCH1}/${REPLACE1}/g" values.yaml

		SEARCH2="notary: mgmt-registry.tank.local"
		export SEARCH2=$SEARCH2
			echo $SEARCH2
        REPLACE2="notary: $CN_ADDRESS"
		export REPLACE2=$REPLACE2
			echo $REPLACE2

 #sed -i "s/${SEARCH2}/${REPLACE2}/g" values.yaml

		SEARCH3="secretName: "tank" "
		export SEARCH3=$SEARCH3
            echo $SEARCH3
        REPLACE3="secretName: $TLS_NAME"
		export REPLACE3=$REPLACE3
            echo $REPLACE3
 #sed -i "s/secretName: ""/${REPLACE3}/g" values1.yaml
 #sed -i "s/secretName: ""/$REPLACE3/g" values.yaml

 #copy files to the server
#scp -i $SSHKEY_PATH $CERT_PATH ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH $KEY_FILE ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH $CRT_FILE ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH ./check.sh ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH ./old_server.sh ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH ./cert_status1.sh ccpuser@10.32.141.35:/home/ccpuser
#scp -i $SSHKEY_PATH ./new_server_cert.sh ccpuser@10.32.141.35:/home/ccpuser


#echo $HOST_NAME
source server.txt
for server in $(cat server.txt)
do
scp $CERT_PATH ccpuser@$server:/home/ccpuser
scp $KEY_FILE ccpuser@$server:/home/ccpuser
scp $CRT_FILE ccpuser@$server:/home/ccpuser
scp ./check_install.sh ccpuser@$server:/home/ccpuser
scp ./old_server.sh ccpuser@$server:/home/ccpuser
scp ./cert_status1.sh ccpuser@$server:/home/ccpuser
scp ./new_server_cert.sh ccpuser@$server:/home/ccpuser
scp ./server.txt ccpuser@$server:/home/ccpuser
scp ./server1.txt ccpuser@$server:/home/ccpuser
scp ./cert_update.sh ccpuser@$server:/home/ccpuser
scp ./inputfile.txt ccpuser@$server:/home/ccpuser
scp ./harbor.zip ccpuser@$server:/home/ccpuser

sed -i -e 's/\r$//' ./check_install.sh
sed -i -e 's/\r$//' ./old_server.sh
sed -i -e 's/\r$//'  ./cert_status1.sh
sed -i -e 's/\r$//' ./old_server.sh
sed -i -e 's/\r$//' ./new_server_cert.sh
sed -i -e 's/\r$//' server.txt
sed -i -e 's/\r$//' server1.txt
sed -i -e 's/\r$//' ./cert_update.sh
sed -i -e 's/\r$//' inputfile.txt
sed -i -e 's/\r$//' harbor.zip

done 
echo "check1"
#for x in `cat inputfile.txt
#	do host $HOST_NAME  ` 
for server in $(cat server.txt)
do
echo $server
ssh ccpuser@$server /bin/bash <<EOF
#ssh -i $SSHKEY_PATH ccpuser@10.32.141.35 /bin/bash <<EOF
pwd;
hostname;
ls;
#kubectl get namespace | fgrep harbor
echo "further run "
chmod +x check.sh
echo "execute check.sh now"
./check_install.sh

EOF
done

#for server in $(cat server1.txt)
#do
#	echo $server
#	ssh ccpuser@$server /bin/bash <<EOF
#ls
#chmod +x cert_update.sh
#./cert_update.sh

#EOF
#done
