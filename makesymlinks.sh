#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
############################

function usage {
    echo "usage: $0 [-i] [-h]"
    echo
    echo "    -i    interactive - prompt before making each symlink"
    echo "    -h    help - print this message"
    echo
} 

# Parse args
interactive=false
while getopts "hi" opt; do
    case $opt in
        h)
            usage            
            exit 0
            ;;
        i)
            interactive=true
            ;;
        *)
            usage
            exit 0
            
    esac
done

exit

########## Variables

dir=~/dotfiles # dotfiles directory
olddir=~/.dotfiles_old # old dotfiles backup directory
files="elisp emacs gitconfig profile tmux.conf vimrc zephyros.js" # list of files/folders to symlink in homedir

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir"
for file in $files; do
    # if run with -i parameter, prompt user before creating each symlink
    if [ $interactive ]
    then
        read -p "Create symlink to $file in home directory? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            mv ~/.$file $olddir/
            echo "Creating symlink to $file in home directory."
            ln -s $dir/$file ~/.$file
        fi
    # otherwise just go ahead and create them
    else
        mv ~/.$file $olddir/
        echo "Creating symlink to $file in home directory."
        ln -s $dir/$file ~/.$file
    fi
done
