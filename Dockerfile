FROM archlinux/archlinux
ENV USER=root
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
