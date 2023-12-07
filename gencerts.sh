#!/bin/bash

rm -r private certs
mkdir private certs

# CA cert
openssl ecparam -out private/ca.pem -name prime256v1 -genkey
openssl req -x509 -new -nodes -key private/ca.pem -days 3650 -out certs/ca.pem -config conf/ca.cnf

# Server cert
openssl ecparam -out private/server.pem -name prime256v1 -genkey
openssl req -config conf/server.cnf -new -key private/server.pem -out certs/server-csr.pem
openssl x509 -req -in certs/server-csr.pem -CA certs/ca.pem -CAkey private/ca.pem -CAcreateserial -out certs/server.pem -days 365 -extensions v3_req -extfile conf/server.cnf

# Client cert
# openssl ecparam -out private/client.pem -name prime256v1 -genkey
openssl genrsa -out private/client.pem 4096
openssl req -config conf/client.cnf -new -key private/client.pem -out certs/client-csr.pem
openssl x509 -req -in certs/client-csr.pem -CA certs/ca.pem -CAkey private/ca.pem -CAcreateserial -out certs/client.pem -days 365 -extensions v3_req -extfile conf/client.cnf
