#!/bin/bash

dotfiles='dotfiles.personal'

ln -sf ~/$dotfiles/.zshrc ~/.config/zshrc/01-evals

ln -sf ~/$dotfiles/.gitconfig* ~/

ln -sf ~/$dotfiles/neofetch.conf ~/.config/neofetch/config.conf

ln -sf ~/$dotfiles/ghostty.conf ~/.config/ghostty/config

ln -sf ~/$dotfiles/nvim ~/.config/nvim

ln -s ~/$dotfiles/keyboard/default.conf ~/.config/hypr/conf/keybindings/default.conf

ln -s ~/$dotfiles/keyboard/keyboard.conf ~/.config/hypr/conf/keyboard.conf
