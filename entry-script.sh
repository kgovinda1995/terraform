#!/bin/bash
sleep 30
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y docker.io
systemctl enable docker
systemctl start docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker root
systemctl enable docker
systemctl start docker

sudo docker run -d -p 8090:80 nginx