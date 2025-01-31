#!/bin/zsh

dotfiles='dotfiles.personal'

mv ~/.zshrc ~/.zshrc.old
ln -s ~/$dotfiles/.zshrc ~/.config/zshrc/01-evals

mv ~/.gitconfig* ~/.gitconfig*.old
ln -s ~/$dotfiles/.gitconfig* ~/

mv ~/.config/neofetch/config.conf ~/.config/neofetch/config.conf.old
ln -s ~/$dotfiles/neofetch.conf ~/.config/neofetch/config.conf

mv ~/.config/ghostty/config ~/.config/ghostty/ghostty.old
ln -s ~/$dotfiles/ghostty.conf ~/.config/ghostty/config

mv ~/.config/nvim ~/.config/nvim.old
ln -s ~/$dotfiles/nvim ~/.config/nvim

mv ~/.config/hypr/conf/keybindings/default.conf ~/.config/hypr/conf/keybindings/default.conf.old
ln -s ~/$dotfiles/keyboard/default.conf ~/.config/hypr/conf/keybindings/default.conf

mv ~/.config/hypr/conf/keyboard.conf ~/.config/hypr/conf/keyboard.conf.old
ln -s ~/$dotfiles/keyboard/keyboard.conf ~/.config/hypr/conf/keyboard.conf

mv ~/dotfiles/waybar ~/$dotfiles/waybar
ls -s ~/$dotfiles/waybar ~/.config/waybar

ln -s ~/$dotfiles/finder.sh ~/.config/rofi/finder.sh

mv ~/.config/rofi/config.rasi ~/.config/rofi/config.rasi.old
ln -s ~/$dotfiles/config.rasi ~/.config/rofi/config.rasi
