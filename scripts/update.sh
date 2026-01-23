#!/bin/bash

dotfiles='dotfiles.personal'

ln -sf ~/$dotfiles/.zshrc ~/.config/zshrc/01-evals

ln -sf ~/$dotfiles/.gitconfig* ~/

ln -sf ~/$dotfiles/neofetch.conf ~/.config/neofetch/config.conf

ln -sf ~/$dotfiles/ghostty.conf ~/.config/ghostty/config

#TODO: this create a recursve nvim link
ln -sf ~/$dotfiles/nvim ~/.config/nvim

ln -sf ~/$dotfiles/keyboard/default.conf ~/.config/hypr/conf/keybindings/default.conf

ln -sf ~/$dotfiles/keyboard/keyboard.conf ~/.config/hypr/conf/keyboard.conf

ln -sf ~/$dotfiles/waybar ~/.config/waybar

ln -sf ~/$dotfiles/finder.sh ~/.config/rofi/finder.sh

ln -sf ~/$dotfiles/config.rasi ~/.config/rofi/config.rasi

ln -sf ~/$dotfiles/swaync ~/.config/swaync 
