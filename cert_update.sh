#!/bin/bash
var1=/home/ccpuser/harbor_bkp/automation/root

cd /usr/local/share/ca-certificates/
sudo cp $var1/*.pfx .
sudo cp $var1/*.crt .
sudo cp $var1/*.key .

sudo chmod  644 /usr/local/share/ca-certificates/*.crt
sudo chmod  644 /usr/local/share/ca-certificates/*.key
sudo update-ca-certificates
