#!/bin/sh
ctags --recurse --langmap=Java:.java --languages=Java -f ~/.vim/tags $ANDROID_HOME/sources
