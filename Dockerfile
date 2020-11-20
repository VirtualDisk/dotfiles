FROM archlinux/archlinux:base-devel
# FROM ubuntu:latest
ENV USER=root
# RUN apt update && apt install sudo
RUN pacman -Syu sudo --noconfirm 
WORKDIR /.dotfiles
COPY . /.dotfiles
RUN "/.dotfiles/bootstrap.sh"
