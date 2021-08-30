#!/usr/bin/env bash
# Creates simple self-signed certificates to use with TCP/TLS module
# by default, the script:
# 1) Creates "certs" folder in the current folder
# 2) Starts from node ID 0
#
# Examples usage:
# 1) To create 10 certificates folders with node IDs 0 to 9 in "./certs:
# > ./create_tls_certs.sh 10
#
# 2) To create 15 certificates folders with node IDs 0 to 14 in "/tmp/abc/:
# > ./create_tls_certs.sh 15 /tmp/abc
#
# 3) To create 30 certificates folders with node IDs 5 to 34 in "/tmp/fldkdsZ/:
# > ./create_tls_certs.sh 30 /tmp/fldkdsZ 5

if [ "$#" -eq 0 ] || [ -z "$1" ]; then
   echo "usage: create_tls_certs.sh {num of replicas} {optional - output folder} {optional - start node ID}"
   exit 1
fi

dir=$2
if [ -z "$dir" ]; then
   dir="certs"
fi

start_node_id=$3
if [ -z "$start_node_id" ]; then
   start_node_id=0
fi

i=$start_node_id
last_node_id=$((i + $1 - 1))
while [ $i -le $last_node_id ]; do
   echo "processing replica $i/$last_node_id"
   clientDir=$dir/$i/client
   serverDir=$dir/$i/server

   mkdir -p $clientDir
   mkdir -p $serverDir

   openssl ecparam -name secp384r1 -genkey -noout -out $serverDir/pk.pem
   openssl ecparam -name secp384r1 -genkey -noout -out $clientDir/pk.pem

   openssl req -new -key $serverDir/pk.pem -nodes -days 365 -x509 \
        -subj "/C=NA/ST=NA/L=NA/O=NA/OU=${i}/CN=node${i}ser" -out $serverDir/server.cert

   openssl req -new -key $clientDir/pk.pem -nodes -days 365 -x509 \
        -subj "/C=NA/ST=NA/L=NA/O=NA/OU=${i}/CN=node${i}cli" -out $clientDir/client.cert

   (( i=i+1 ))
done

exit 0