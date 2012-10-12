#!/bin/sh
ANDROID_HOME=/opt/google/android/android-sdk-linux
ctags --recurse --langmap=Java:.java --languages=Java -f ~/.vim/tags $ANDROID_HOME/sources
