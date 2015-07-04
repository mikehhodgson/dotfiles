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
       -d    debug - set -x
       -h    help - print this message
       -s    silent - don't prompt before each file
    EOF
}

options() {
    while getopts "cdhs" opt; do
        case $opt in
            c)
                readonly COPY=true
                ;;
            d)
                set -x
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

make_dotfile() {
    if [[ "$COPY" == true ]];
    then
        echo "Copying $file to home directory."
        cp -r $1 $2
    else
        echo "Creating symlink to $file in home directory."
        ln -s $1 $2
    fi
}

main() {
    options $ARGS

    # dotfiles directory
    local dir=~/dotfiles
    # old dotfiles backup directory
    local olddir=~/.dotfiles_old
    # list of files/folders to symlink in homedir
    local files="elisp emacs gitconfig gtkrc-2.0.gnucash hydra phoenix.js profile tmux.conf vimrc zephyros.js"

    # create dotfiles_old in homedir
    # if olddir exists this can cause problems with backing up a symlink where
    # olddir contains a directory of the same name
    if [[ -d $olddir ]];
    then
        if [[ "$SILENT" == true ]];
        then
            rm -rf $olddir
        else
            read -p "Do you wish to remove $olddir?" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]];
            then
                rm -rf $olddir
            else
                exit 1
            fi
        fi
    fi

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
    echo "Any existing dotfiles will be moved from from ~ to $olddir"
    for file in $files; do
        # if run with -s parameter, process all files without prompting
        if [[ "$SILENT" == true ]];
        then
            mv -f ~/.$file $olddir/ 2>/dev/null
            make_dotfile "$dir/$file" ~/.$file
        # otherwise prompt before each file
        else
            read -p "Create symlink to $file in home directory? " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]];
            then
                mv -f ~/.$file $olddir/ 2>/dev/null
                make_dotfile "$dir/$file" ~/.$file
            fi
        fi
    done
}

main
