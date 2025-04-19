FROM docker.io/library/ubuntu:24.04
ENV USER=root
RUN apt update && apt install sudo -y
WORKDIR /root/.dotfiles
COPY . /root/.dotfiles
RUN "/root/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
