!#/bin/zsh

mv ~/.zshrc ~/.zshrc.old
ln -s ~/dotfiles/.zshrc ~/.zshrc

mv ~/.gitconfig* ~/.gitconfig*.old
ln -s ~/dotfiles/.gitconfig* ~/

mv ~/.config/neofetch/config.conf ~/.config/neofetch/config.conf.old
ln -s ~/dotfiles/neofetch.conf ~/.config/neofetch/config.conf
