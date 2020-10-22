#!/bin/bash
loc=$(pwd)
ssh_authorized=~/.ssh/authorized_keys
#ssh_file=~/.ssh/abc.txt
echo $ssh_file
chmod +x $ssh_file
keys_file=$loc/ssh-keys/keys.txt
echo $keys_file
cat "$keys_file" >> "$ssh_file"
eval $(ssh-agent -s)
ssh-add $loc/ssh-keys/management
ssh-add $loc/ssh-keys/entwicklung
ssh-add $loc/ssh-keys/prod
ssh-add $loc/ssh-keys/staging
ssh-add $loc/ssh-keys/coremedia
ssh-add $loc/ssh-keys/istio
ssh-add $loc/ssh-keys/vbgstaging
ssh-add $loc/ssh-keys/id_rsa
