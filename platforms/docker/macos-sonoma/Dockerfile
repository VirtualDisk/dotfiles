FROM docker.io/sickcodes/docker-osx:sonoma
ENV USER=root
WORKDIR /Users/user/.dotfiles
COPY . /Users/user/.dotfiles
RUN "/Users/user/.dotfiles/bootstrap.sh"
ENTRYPOINT ["/usr/bin/zsh"]
