FROM docker.io/library/fedora:41
ENV USER=root
RUN dnf install sudo -y
WORKDIR /root/.dotfiles
COPY . /root/.dotfiles
RUN "/root/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
