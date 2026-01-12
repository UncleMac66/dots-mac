#!/bin/bash

if [ "$(basename "$PWD")" != "dots-machrome" ]; then 
  cd ~/dots-mac
  if [[ "$?" -gt 0 ]]; then
    echo -e "Can't find dots-mac directory!"
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
echo -e "Cleaning Home directory of any dead symlinks..."

find ~ -xtype l -delete

echo -e "Backing up some files req'd for xfce de..."

if [ -d ~/.config/xfce4/xfconf/xfce-perchannel-xml/ ]; then
  for i in $(cat ~/dots-mac/.config/xfce4/xfconf/xfce-perchannel-xml/files); do
  	cp  ~/.config/xfce4/xfconf/xfce-perchannel-xml/$i ~/.config/xfce4/xfconf/xfce-perchannel-xml/$i.bak.$(date -I)
  	mv  ~/.config/xfce4/xfconf/xfce-perchannel-xml/$i ~/dots-mac/.config/xfce4/xfconf/xfce-perchannel-xml/$i
  done
fi

stow --ignore .gitignore . && echo -e "Stowing is successful!"
if [[ "$?" -gt 0 ]]; then
  echo -e "ERROR! Stowing did not complete successfully!"
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

