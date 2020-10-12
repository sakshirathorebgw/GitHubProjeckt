
scp ./cert_state.sh ccpuser@10.32.141.54:/home/ccpuser
echo $hostname
      ssh ccpuser@10.32.141.54 /bin/bash <<EOF

#sed -i -e 's/\r$//' ./cert_state.sh
chmod +x cert_state.sh
#./cert_state.sh
./cert_state.sh
#echo "certificate update"
ls -lrt
echo hostname -i
cd harbor
echo hostname
EOF


