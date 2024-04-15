FROM archlinux/archlinux:base-devel
ENV USER=root
RUN pacman -Syu sudo --noconfirm 
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
