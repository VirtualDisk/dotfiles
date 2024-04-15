FROM ubuntu:latest
ENV USER=root
USER root
RUN apt update && apt install sudo -y
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
USER zoe
ENTRYPOINT ["/usr/bin/zsh"]
