#!/bin/bash
curl -o ./ca.crt http://traefik.me/cert.pem
sudo mkdir -p /etc/containerd/certs.d/harbor-192-168-2-100.traefik.me/
sudo cp ./ca.crt /etc/containerd/certs.d/harbor-192-168-2-100.traefik.me/ca.crt
sudo systemctl restart containerd