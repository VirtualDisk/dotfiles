FROM docker.io/library/ubuntu:24.04
ENV USER=zoe
ENV HOME=/home/$USER
USER root
RUN apt update && apt install sudo -y
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN groupadd -g 420 $USER
RUN useradd -m -u 421 -g $USER $USER && \
  usermod -aG sudo $USER
WORKDIR "$HOME/.dotfiles"
COPY . "$HOME/.dotfiles"
RUN chown -R $USER:$USER $HOME
USER $USER
RUN "pwd"
RUN "./bootstrap.sh"
CMD ["/usr/sbin/sshd"]
