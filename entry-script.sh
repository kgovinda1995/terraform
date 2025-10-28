#!/bin/bash
    apt update -y
    apt install -y docker.io
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu
    echo "Docker installed successfully on $(hostname)" > /home/ubuntu/docker_setup.log
    docker run -d -p 8080:80 nginx