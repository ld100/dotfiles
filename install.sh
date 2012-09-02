#!/usr/bin/env zsh

for found in ~/.dotfiles/dotfiles/*; do
  ln -fs $found ~/.$found:t
done

mkdir -p ~/.ssh 
ln -fs ~/.dotfiles/ssh/authorized_keys ~/.ssh/authorized_keys
