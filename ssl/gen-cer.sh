#!/bin/bash

SCRIPT=`readlink -f $0`
CMD_PATH=`dirname $SCRIPT`

#Required
domain=$1
commonname=$domain
 
#Change to your company details
country=CH
state=SiChuan
locality=ChengDu
organization=wise2c.com
organizationalunit=dev
email=james_zhou@wise2c.com
 
#Optional
password=dummypassword
 
if [ -z "$domain" ]
then
    echo "Argument not present."
    echo "Useage $0 [common name]"
 
    exit 99
fi
 
echo "Generating key request for $domain"
 
#Generate a key
openssl genrsa -des3 -passout pass:$password -out ${CMD_PATH}/$domain.key 2048 -noout
 
#Remove passphrase from the key. Comment the line out to keep the passphrase
echo "Removing passphrase from key"
openssl rsa -in ${CMD_PATH}/$domain.key -passin pass:$password -out ${CMD_PATH}/$domain.key
 
#Create the request
echo "Creating CSR"
#openssl req -new -key $domain.key -out $domain.csr -passin pass:$password \
#    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

openssl req -new -key ${CMD_PATH}/$domain.key -out ${CMD_PATH}/$domain.csr \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

echo "Create CRT by myself"
openssl x509 -req -days 365 -in ${CMD_PATH}/$domain.csr -signkey ${CMD_PATH}/$domain.key -out ${CMD_PATH}/$domain.crt

 
echo "---------------------------"
echo "-----Below is your CSR-----"
echo "---------------------------"
echo
cat ${CMD_PATH}/$domain.csr
 
echo
echo "---------------------------"
echo "-----Below is your Key-----"
echo "---------------------------"
echo
cat ${CMD_PATH}/$domain.key


echo
echo "---------------------------"
echo "-----Below is your crt-----"
echo "---------------------------"
echo
cat ${CMD_PATH}/$domain.crt
