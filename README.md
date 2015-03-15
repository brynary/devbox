docker build -t=devbox .
docker run -it -v $HOME/.ssh:/root/.ssh devbox
