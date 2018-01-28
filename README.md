# Dotfiles

## Install
Clone into ~/.dotfiles and execute the bootstrap script. 
```
git clone git@github.com:jemtucker/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap.sh
```

## Add dotfile
Dotfiles are symlinked from `~/.dotfiles/<SOME_DIR>/*.symlink` into the current
users home directory. Just add a file and re-run the bootstrap script. 

