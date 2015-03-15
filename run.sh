#!/bin/sh
docker run -it -v $HOME/.ssh:/root/.ssh -v $HOME/p:/p devbox
