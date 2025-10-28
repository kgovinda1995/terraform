#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
sudo echo "Docker installed successfully on $(hostname)" > /home/ubuntu/docker_setup.log
sudo docker run -d -p 8080:80 nginx