#!/bin/bash
############################
# makesymlinks.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
# http://www.kfirlavi.com/blog/2012/11/14/defensive-bash-programming/
############################

readonly ARGS="$@"

usage() {
    cat <<- EOF
	usage: $0 [-chs]

	This program creates symlinks in the user's home directory to the
	bundled config files.

	OPTIONS:
	   -c    copy - copy files instead of making symlinks
	   -h    help - print this message
	   -s    silent - don't prompt before each file
	EOF
} 

options() {
    while getopts "chs" opt; do
        case $opt in
            c)
                readonly COPY=true
                ;;
            h)
                usage
                exit 0
                ;;
            s)
                readonly SILENT=true
                ;;
            *)
                usage
                exit 2
                ;;
        esac
    done
}

main() {
    options $ARGS

    # dotfiles directory
    local dir=~/dotfiles
    # old dotfiles backup directory
    local olddir=~/.dotfiles_old
    # list of files/folders to symlink in homedir
    local files="elisp emacs gitconfig profile tmux.conf vimrc zephyros.js"
    
    # create dotfiles_old in homedir
    echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
    mkdir -p $olddir
    echo "done"
    
    # change to the dotfiles directory
    echo -n "Changing to the $dir directory ..."
    cd $dir
    echo "done"
    
    # move any existing dotfiles in homedir to dotfiles_old directory,
    # then create symlinks from the homedir to any files in the
    # ~/dotfiles directory specified in $files
    echo "Moving any existing dotfiles from ~ to $olddir"
    for file in $files; do
        # if run with -s parameter, process all files without prompting
        if [[ "$SILENT" == true ]];
        then
            mv "~/.$file" "$olddir/"
            echo "Creating symlink to $file in home directory."
            if [[ "$COPY" == true ]];
            then
                cp "$dir/$file" "~/.$file"
            else
                ln -s "$dir/$file" "~/.$file"
            fi
        # otherwise prompt before each file
        else
            read -p "Create symlink to $file in home directory? " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]];
            then
                mv "~/.$file" "$olddir/"
                echo "Creating symlink to $file in home directory."
                if [[ "$COPY" == true ]];
                then
                    echo "cp $dir/$file ~/.$file"
                    cp "$dir/$file" "~/.$file"
                else
                    echo "ln -s $dir/$file ~/.$file"
                    ln -s "$dir/$file" "~/.$file"
                fi
            fi
        fi
    done
}

main