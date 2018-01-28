#!/usr/bin/env bash
# 
# 
# 

DOTFILES_HOME=~/.dotfiles

function exit_on_error() {
    if [ $? -ne 0 ]; then
        printf "\r$(basename -- $0):%d:error: %s\n" $BASH_LINENO "$1"
        exit
    fi
}

function warn() {
    printf "\r$(basename -- $0):%d:warn: %s\n" $BASH_LINENO "$1"
}

function fail() {
    printf "\r$(basename -- $0):%d:error: %s\n" $BASH_LINENO "$1"
    exit
}

function info() {
    printf "\r$(basename -- $0):%d:info: %s\n" $BASH_LINENO "$1"
}

function link_file () {
    local src=$1 
    local dst=$2

    local create=true
    
    if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]; then
        local backup=false
        local delete=false
        local action=
        
        warn "File already exists: $dst ($(basename "$src"))  [s]kip, [o]verwrite, [b]ackup?"
        read -n 1 action

        case "$action" in
            o )
                delete=true;;
            b )
                backup=true;;
            s )
                create=false;;
            * )
                fail "Error linking $src -> $dst";;
        esac  
        
        if $delete ; then
            rm -f "$dst"
            exit_on_error "Unable to delete $dst"
        fi

        if $backup ; then
            mv "$dst" "${dst}.bkp"
            exit_on_error "Unable to backup $dst"
        fi
    fi
    
    if $create ; then
        ln -s "$src" "$dst"
        
        exit_on_error "Error linking $src -> $dst"
        
        info "Link created: $src -> $dst"
    fi
}

function bootstrap() {
    local src=
    for src in $(find -H "$DOTFILES_HOME" -maxdepth 2 -name '*.symlink' -not -path '*.git*'); do
        dst="$HOME/.$(basename "${src%.*}")"
        link_file "$src" "$dst"
    done
}

bootstrap

info "Completed!"
