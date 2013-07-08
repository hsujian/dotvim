dotvim
======

my .vim

dotvim is my own vim setting. It comes bundled with a ton of helpful functions, helpers, plugins, themes, and few things that make you shout...

##Setup

### The automatic installer... (do you trust me?)

You can install this via the command line with either `curl` or `wget`.

####via `curl`

`curl -L https://github.com/xudejian/dotvim/raw/master/tools/install.sh | sh`

####via `wget`

`wget --no-check-certificate https://github.com/xudejian/dotvim/raw/master/tools/install.sh -O - | sh`

### The manual way


1. Clone the repository

  `git clone git://github.com/xudejian/dotvim.git ~/.vim`

2. *OPTIONAL* Backup your existing ~/.vimrc file

  `cp ~/.vimrc ~/.vimrc.orig`

3. Create a new .vimrc by linking the vimrc we've provided.

  `ln -s ~/.vim/vimrc ~/.vimrc`


4. Install Submodule:

  `cd .vim && git submodule update --init && cd ..`  

5. Install vim plugins

  `vim +BundleInstall +qall`  
