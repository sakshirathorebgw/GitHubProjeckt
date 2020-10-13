#!/bin/sh

# Define some variables

#ssh ccpuser@10.32.141.54 /bin/bash 
errorCode=0
 
# Sender Address
# Specify here the sender address of the notification mails
sender="SSL Certificate Notification <Sakshi.Rathore@bgw-online.de>"
 
# SMTP gateway 
# Define here the full qualified DNS name of the SMTP gateway which should be used to send notification mails.
smtpmx="Sakshi.Rathore@bgw-online.de"
 
# Recipients address where to send notification mails
recipients="Sakshi.Rathore@bgw-online.de"
 
# Check if at least one parameter is given; if yes, use that as hostName:port
#if [ -z "$1" ] 
#then
 #   echo "Usage: ./checkSSLExpiration.sh hostname:port [warning_days]"
 #   exit 1
#else
 #   hostNameWithPort=$1
#fi
 
#hostName=`echo $hostNameWithPort | cut -d: -f 1`
#port=`echo $hostNameWithPort | cut -d: -f 2 -s`
 
# If there is no port number, use 443 as default
#if [ "$port" == "" ] 
#then
 #   port="443"
 #   hostNameWithPort="$hostName:$port"
#fi
 
# Check if a second parameter is given; if yes, use that as warning_days. If not, use 30 days as default
#cp ./old_server.sh harbor
#ssh ccpuser@10.32.141.54 /bin/bash <<EOF

cd harbor

if [ -z "$2" ]
then
   warning_days="265"
else
   warning_days=$2
fi

OLD_CERTFILE=$(find ./ -maxdepth 1  -type f -name "*.crt" -printf "%T@ %p\n" | sort -n | cut -d' ' -f 2- | tail -n 1 )
		export OLD_CERTFILE=$OLD_CERTFILE
		echo $OLD_CERTFILE
	OLD_CERTFILENAME=$(basename $OLD_CERTFILE)
		export OLD_CERTFILENAME=$OLD_CERTFILENAME
		echo $OLD_CERTFILENAME

# Get the expiration date and time for the certificate
expirationdate=`date --date="$( echo | openssl x509 -noout -in $OLD_CERTFILENAME -enddate  | cut -d= -f 2)"`

# Get the expiration date and time for the certificate as number of seconds
expirationdate_days=`date --date="$( echo | openssl x509 -noout -in $OLD_CERTFILENAME  -enddate  | cut -d= -f 2)"  "+%s"`
 
# Ge the current date / time as nnumber of seconds
today_days=$(date -d "today" "+%s")
 
# Calculcate the difference of the two times and convert it to days
numberOfDays=$(( ($expirationdate_days - $today_days)/(60*60*24) ))
 
# Report the result
echo " "
echo "The certificate of"
echo "   $hostName"
echo "expires on"
echo "   $expirationdate"
echo "which is in $numberOfDays days from now!"

if [ $numberOfDays -gt $warning_days ]
then
    # evertyhing ok, the certificate will expire later than the warning_days
    echo " "
    echo "OK - Expiration date is more than $warning_days days in future."
    echo " "
    errorCode=0
elif [ $numberOfDays -le 0 ]
then
    # Report ERROR as the certificate has already expired
    echo " "
    echo "ERROR - Certificate has expired!"
    echo " "
    errorCode=99
    subject="$hostName - SSL Certificate has expired"
    body="ATTENTION: The certificate of $hostName has expired on $expirationdate!"
    echo "edit properties file and run the job to install the new certs"
    cd 
    #mv harbor harbor_bkp
    chmod +x old_server.sh
    ./old_server.sh
else
    # Report WARNING as the certificate will expire within warning_days.
    echo " "
    echo "WARNING - Expiration date is near!"
    echo " "
    errorCode=10
    subject="$hostName - SSL Certificate expires in $numberOfDays days"
    body="ATTENTION: The certificate of $hostName expires on $expirationdate which is in $numberOfDays days from now!, issue new certificate and install new harbor certificate on the server"
    echo "edit properties file and run the job to install the new cert"
    cd 
    #mv harbor harbor_bkp
    chmod +x old_server.sh
    ./old_server.sh
fi
 
if [ "$errorCode" -eq 0 ]; then 
    # No errors found. Just end
    exit $errorCode
else
    # Send notification mail
    #echo -e $body | /bin/mailx -v -s "$subject" -S smtp=smtp://$smtpmx  -r "$sender" $recipients  >/dev/null 2>&1
   # echo -e $body | mail -s "certtificate installation alert" Sakshi.Rathore@bgw-online.de
    echo "Mail notification sent"
    echo " "
    exit $errorCode
fi
