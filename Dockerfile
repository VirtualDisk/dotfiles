FROM archlinux/archlinux:base-devel
# FROM ubuntu:latest
ENV USER=root
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
