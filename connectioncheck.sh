#!/bin/bash
USERNAME=ccpuser
HOSTS="10.32.141.38"
SCRIPT="pwd; ls"
for HOSTNAME in ${HOSTS} ; do
    ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
done
