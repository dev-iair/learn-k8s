#!/bin/bash

# 사용자로부터 URL 입력 받기
read -p "Enter the URL for local registry: " REGISTRY_SERVER_URL

# Docker 데몬 설정 파일 경로
DOCKER_DAEMON_JSON="/etc/docker/daemon.json"

# 새로운 JSON 구조
NEW_JSON="{\"insecure-registries\": [\"$REGISTRY_SERVER_URL\"]}"

echo "$NEW_JSON" | sudo tee "$DOCKER_DAEMON_JSON" > /dev/null