#!/bin/bash
source server.txt
for server in $(cat server.txt)
do
  scp /home/ccpuser/harbor_bkp/automation/check.sh "$server":/home/ccpuser
  ssh ccpuser@$server
  ./check.sh
done
