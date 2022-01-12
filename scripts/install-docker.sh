#!/bin/bash

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sh
usermod -a -G docker $1

echo "Installing Docker Compose..."
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
