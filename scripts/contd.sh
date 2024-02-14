#!/bin/bash
read -p "Enter the IP address of the local docker registry: " ip

file="/etc/containerd/config.toml"

search_config="\[plugins.\"io.containerd.grpc.v1.cri\".registry\]"
replace_config="\[plugins.\"io.containerd.grpc.v1.cri\".registry\]\n\n      \[plugins.\"io.containerd.grpc.v1.cri\".registry.configs\]\n\n        \[plugins.\"io.containerd.grpc.v1.cri\".registry.configs.\"$ip\".tls\]\n          insecure_skip_verify = true"

search_mirror="\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors\]"
replace_mirror="\[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors\]\n\n        \[plugins.\"io.containerd.grpc.v1.cri\".registry.mirrors.\"$ip\"\]\n          endpoint = \[\"http\:\/\/$ip\"\]"

sudo sed -i "s/${search_config}/${replace_config}/g" $file
sudo sed -i "s/${search_mirror}/${replace_mirror}/g" $file

sudo systemctl restart containerd