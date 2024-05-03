FROM docker.io/library/rockylinux:9.3-minimal
ENV USER=root
RUN dnf install sudo -y
WORKDIR /root/.dotfiles
COPY . /root/.dotfiles
RUN "/root/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
