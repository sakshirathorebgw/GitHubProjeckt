#!/bin/bash

CN_NAME= $(openssl x509 -noout -subject -in test2-harbor.crt | awk '{ print $18 }' | sed 's/.$//')
echo $CN_NAME
