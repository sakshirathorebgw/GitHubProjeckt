#!/bin/bash
var1=$pwd

cd /usr/local/share/ca-certificates/
#sudo cp $var1/*.pfx .
sudo cp $var1/test-harbor.crt .
sudo cp $var1/test-harbor.key .

sudo chmod  644 /usr/local/share/ca-certificates/*.crt
sudo chmod  644 /usr/local/share/ca-certificates/*.key
sudo update-ca-certificates
