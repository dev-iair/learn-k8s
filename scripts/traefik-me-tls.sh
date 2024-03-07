#!/bin/bash

# Save user input for namespace name
read -p "Enter the namespace name: " NS_NAME

# Define URLs for downloading files
CERT_URL="http://traefik.me/cert.pem"
KEY_URL="http://traefik.me/privkey.pem"

# Download files and create secret
curl -o cert.pem $CERT_URL
curl -o privkey.pem $KEY_URL

# Create TLS secret in Kubernetes cluster
kubectl create secret tls $NS_NAME-tls --cert=cert.pem --key=privkey.pem -n $NS_NAME

# Clean up temporary files
rm cert.pem privkey.pem