#!/bin/bash

# Define URLs for downloading files
CERT_URL="http://traefik.me/cert.pem"
KEY_URL="http://traefik.me/privkey.pem"

# Download files and create secret
curl -o cert.pem $CERT_URL
curl -o privkey.pem $KEY_URL
