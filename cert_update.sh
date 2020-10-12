#!/bin/bash
var1=/home/ccpuser/
 
 #rm *.crt
 #rm *.key

CRT_FILE=$(find ./ -maxdepth 1  -type f -name "*.crt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
KEY_FILE=$(find ./ -maxdepth 1  -type f -name "*.key" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )

CRT=$(basename $CRT_FILE)
KEY=$(basename $KEY_FILE)
: '
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
'

cd /usr/local/share/ca-certificates/
#sudo cp $var1/*.pfx .
sudo cp $CRT .
sudo cp $KEY .



sudo chmod  644 /usr/local/share/ca-certificates/*.crt
sudo chmod  644 /usr/local/share/ca-certificates/*.key
sudo update-ca-certificates
