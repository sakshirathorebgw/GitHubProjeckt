#!/bin/bash
var1=$(pwd)

cd /usr/local/share/ca-certificates/
sudo cp $var1/*.pfx .
sudo cp $var1/*.crt .
sudo cp $var1/*.key .

sudo chmod -R 644 /usr/local/share/ca-certificates/
sudo update-ca-certificates
