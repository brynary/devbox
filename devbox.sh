#!/bin/sh

if [ -z "$DOCKER_CERT_PATH" ]; then
  if [ -e "/usr/local/bin/boot2docker" ]; then
    `boot2docker shellinit`
  fi
fi

if ! docker port devbox 22/tcp > /dev/null 2>&1; then
  if docker ps -a | grep devbox > /dev/null 2>&1; then
    echo "Booting devbox..."
    docker start devbox > /dev/null
  else
    echo "Creating devbox..."
    docker run --name=devbox -d \
      -v $HOME/.ssh/id_rsa:/home/dev/.ssh/id_rsa \
      -v $HOME/.ssh/id_rsa.pub:/home/dev/.ssh/authorized_keys \
      -v $HOME/p:/p \
      -p 2222:22 \
      devbox > /dev/null
  fi
fi

echo "Connecting to devbox..."
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -A -p 2222 dev@boot2docker
