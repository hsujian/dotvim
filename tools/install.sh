if [ -d ~/.vim ]
then
  echo "\033[0;33mYou already have vim setting.\033[0m You'll need to remove ~/.vim if you want to install"
  exit
fi

echo "\033[0;34mCloning dotvim...\033[0m"
hash git >/dev/null && /usr/bin/env git clone https://github.com/xudejian/dotvim.git ~/.vim || {
  echo "git not installed"
  exit
}

echo "\033[0;34mLooking for an existing vimrc config...\033[0m"
if [ -f ~/.vimrc ] || [ -h ~/.vimrc ]
then
  echo "\033[0;33mFound ~/.vimrc.\033[0m \033[0;32mBacking up to ~/.vimrc.pre-dotvim\033[0m";
  mv ~/.vimrc ~/.vimrc.pre-dotvim;
fi

echo "\033[0;34mUsing the dotvim vimrc file \033[0m"
ln -s ~/.vim/vimrc ~/.vimrc

echo "\033[0;34mInstall submodule \033[0m"
cd .vim && git submodule update --init && cd ..

echo "\033[0;34mInstall vim plugins \033[0m"
vim +BundleInstall +qall

echo "\n\n \033[0;32m....is now installed.\033[0m"

echo "\n\n \033[0;32m you need make your vimproc \033[0m"
