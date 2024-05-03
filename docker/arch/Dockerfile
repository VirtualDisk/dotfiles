FROM docker.io/archlinux/archlinux:base-devel
ENV USER=root
RUN pacman -Syu sudo --noconfirm 
WORKDIR /root/.dotfiles
COPY . /root/.dotfiles
RUN "/root/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
