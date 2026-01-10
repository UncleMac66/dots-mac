#!/bin/bash

if [ "$(basename "$PWD")" != "dots-machrome" ]; then 
  cd ~/dots-mac
  if [[ "$?" -gt 0 ]]; then
    echo -e "Can't find dots-machrome directory!"
    exit 1
  fi
fi

echo -e "----------"
echo -e "Attempting to pull changes..."
echo -e "----------\n"
git pull
if [[ "$?" -gt 0 ]]; then
  echo -e "ERROR! Pulling!"
  exit 1
fi

echo -e "\n----------"
echo -e "Attempting to stow changes..."
echo -e "----------\n"
echo -e "Backing up some files..."

if [ -f ~/.bashrc ]; then
  cp ~/.bashrc ~/.bashrc.bak
  rm ~/.bashrc
fi

if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/ ]; then
  for i in $(cat ~/dots-mac/.config/xfce4/xfconf/xfce-perchannel-xml/files); do
  	mv ~/.config/xfce4/xfconf/xfce-perchannel-xml/$i ~/.config/xfce4/xfconf/xfce-perchannel-xml/$i.bak
  done
fi

stow --ignore .gitignore . && echo -e "Success!"
if [[ "$?" -gt 0 ]]; then
  echo -e "ERROR! Stowing!"
  exit 1
fi

echo -e "\n----------"
echo -e "Attempting to commit any changes..."
echo -e "----------\n"
git commit -am "$(date) - updates" 
if [[ "$?" -gt 0 ]]; then
  exit 1
fi

echo -e "\n----------"
echo -e "Attempting to push changes..."
echo -e "----------\n"
git push
if [[ "$?" -gt 0 ]]; then
  echo -e "ERROR! Pushing!"
  exit 1
fi

echo -e "\n----------"
echo -e "git status..."
echo -e "----------\n"
git status
if [[ "$?" -gt 0 ]]; then
  exit 1
fi

