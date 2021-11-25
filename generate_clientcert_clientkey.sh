#!/bin/bash
## This script is used to Generate the self signed Certificates and Keys
## 
## Useage:  

## 			$ generate_clientcert_clientkey.sh <common name>

## VERSION 1.0
## DATE: 20th November 2021
## Author: Nandhakumar Madheshwaran

BASE=`pwd`  # Files will be generated at current working directory
domain=$1
commonname=$domain

#Change to your company details
country="IN"
state="MH"
locality="Pune"
organization="Red Hat Inc"
organizationalunit="Support Delivery"
email="root@${commonname}"


#CA KEY informations
# By default the CA Certificate and Keys are assumed to use in the below names.
CA_KEY=${BASE}/ca-key.pem
CA_CERT=${BASE}/ca-cert.pem


# Output file Names
CLIENT_REQ=${BASE}/client-req.pem
CLIENT_CERT=${BASE}/client-cert.pem
CLIENT_KEY=${BASE}/client-key.pem

# If argument is not given exit the script
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"

    exit 99
fi

echo "Generating the Client Key and Client Certificate Signing Request for $commonname"
openssl req -newkey rsa:2048 -days 3600 -sha256 -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" -nodes -keyout ${CLIENT_KEY} -out ${CLIENT_REQ}
sleep 1
echo "Rekeying......"
openssl rsa -in ${CLIENT_KEY} -out ${CLIENT_KEY}
sleep 1
echo "Generating the Signed Client Key and Client Certificate for $commonname"
openssl x509 -req -in ${CLIENT_REQ} -days 3600 -sha256 -CA ${CA_CERT} -CAkey ${CA_KEY} -set_serial 01 -out ${CLIENT_CERT}










