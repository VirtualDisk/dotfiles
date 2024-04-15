FROM debian:latest
ENV USER=root
RUN apt update && apt install sudo -y
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
