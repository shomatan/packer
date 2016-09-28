#!/bin/bash

yum -y install git
curl -sS https://raw.githubusercontent.com/shomatan/init-scripts/master/init.sh | bash
curl -sS https://raw.githubusercontent.com/shomatan/init-scripts/master/neovim.sh | bash
curl -sS https://raw.githubusercontent.com/shomatan/dotfiles/master/tools/install.sh | bash


# Install dotfiles
su - vagrant -c "curl -sS https://raw.githubusercontent.com/shomatan/dotfiles/master/tools/install.sh | bash"
chsh -s /bin/zsh vagrant
