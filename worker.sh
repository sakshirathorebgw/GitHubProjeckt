for server in $(cat server1.txt)
do
scp $CERT_PATH ccpuser@$server:/home/ccpuser
scp $KEY_FILE ccpuser@$server:/home/ccpuser
scp $CRT_FILE ccpuser@$server:/home/ccpuser
scp ./check.sh ccpuser@$server:/home/ccpuser
scp ./old_server.sh ccpuser@$server:/home/ccpuser
scp ./cert_status1.sh ccpuser@$server:/home/ccpuser
scp ./new_server_cert.sh ccpuser@$server:/home/ccpuser
scp ./server.txt ccpuser@$server:/home/ccpuser
scp ./server1.txt ccpuser@$server:/home/ccpuser
scp ./cert_update.sh ccpuser@$server:/home/ccpuser
scp ./inputfile.txt ccpuser@$server:/home/ccpuser
scp ./harbor.zip ccpuser@$server:/home/ccpuser

sed -i -e 's/\r$//' ./check.sh
sed -i -e 's/\r$//' ./old_server.sh
sed -i -e 's/\r$//'  ./cert_status1.sh
sed -i -e 's/\r$//' ./old_server.sh
sed -i -e 's/\r$//' ./new_server_cert.sh
sed -i -e 's/\r$//' server.txt
sed -i -e 's/\r$//' server1.txt
sed -i -e 's/\r$//' ./cert_update.sh
sed -i -e 's/\r$//' inputfile.txt
sed -i -e 's/\r$//' harbor.zip

       echo $server
      ssh ccpuser@$server /bin/bash <<EOF

sed -i -e 's/\r$//' cert_update.sh
chmod +x cert_update.sh
./cert_update.sh
echo "certificate update"
ls -lrt
echo hostname -i

EOF
done

