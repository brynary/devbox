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
    sleep 1
  else
    echo "Creating devbox..."
    docker run --name=devbox -d \
      -v $HOME/.ssh/id_rsa:/home/dev/.ssh/id_rsa \
      -v $HOME/.ssh/google_compute_engine:/home/dev/.ssh/google_compute_engine \
      -v $HOME/.ssh/google_compute_engine.pub:/home/dev/.ssh/google_compute_engine.pub \
      -v $HOME/.ssh/id_rsa.pub:/home/dev/.ssh/authorized_keys \
      -v $HOME/p:/p \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -p 2222:22 \
      -p 3000:3000 \
      devbox > /dev/null
    sleep 3
  fi
fi

echo "Connecting to devbox..."
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -A -p 2222 dev@192.168.59.103
