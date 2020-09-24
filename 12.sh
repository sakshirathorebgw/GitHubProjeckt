#kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME  --namespace harbor

 cat ca.crt |base64 | tr -d "\n" > ca.crt.txt
 sed -i '1s/^/  ca.crt: /' ca.crt.txt

 #kubectl create secret tls $TLS_NAME --key $KEY_FILENAME --cert $CRT_FILENAME --namespace harbor
 #kubectl get secret $TLS_NAME -n harbor -o yaml > ca.crt.yaml

 #sed -i '/data:/r ca.crt.txt' ca.crt.yaml
 awk 'FNR==3{system("cat ca.crt.txt")} 1' ca.crt.yaml > ca.crt_final.yaml

kubectl apply -f ca.crt.yaml


 #helm install harbor . -n harbor
 #helm upgrade harbor -n harbor
 echo "Harbor certificate isntallation don
