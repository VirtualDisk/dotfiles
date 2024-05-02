FROM docker.io/libraru/debian:trixie
ENV USER=root
RUN apt update && apt install sudo -y
WORKDIR /root/.dotfiles
COPY . /root/.dotfiles
RUN "/root/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
