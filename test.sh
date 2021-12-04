#!/usr/bin/env bash
docker build -t dotfiles_test . && docker run -it dotfiles_test
