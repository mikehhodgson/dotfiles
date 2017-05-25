#!/usr/bin/env bash

# git clone https://github.com/mikehhodgson/dotfiles.dot ~/dotfiles
#~/dotfiles/makesymlinks.sh

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew install tmux

# emacs form homebrew is just a shell script to launch the Emacs.app

# "which emacs" to determine the shell script
# view the contents to determine the location of the app folder
# copy the app to /Applications so that spotlight can launch it

# /usr/local/Cellar/emacs/24.5/Emacs.app copy it to /Applications so
# that spotlight can find it - the brew link currently doesn't work
brew install emacs --with-cocoa --with-gnutls --with-imagemagick@6 --with-librsvg --with-mailutils
cp -r /usr/local/Cellar/emacs/25.1/Emacs.app /Applications/
