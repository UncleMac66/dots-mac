#!/bin/bash

# Check if the config file exists, if not create it
if [ ! -f ~/.ssh/config ]; then
  touch ~/.ssh/config
  chmod 600 ~/.ssh/config
fi

# Prompt for hostname 
echo "Enter the hostname"
read hostname

# If nothing inputted then reprompt user
while [ -v $hostname ] ; do
  echo "Nothing entered"
  echo "Please input a hostname"
  read hostname
done

# Check if host already exists in config file then reprompt user
while grep -q "$hostname" ~/.ssh/config; do
  echo "Host $hostname already exists in ~/.ssh/config."
  echo "Please input a different hostname"
  read hostname
done

echo "Enter the IP Address"
read ip

# Check if IP is valid, if not then reprompt user
if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo "Invalid IP address. Please enter a valid IP address in the format XXX.XXX.XXX.XXX:"
  read ip
  while ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
    echo "Invalid IP address. Please enter a valid IP address in the format XXX.XXX.XXX.XXX:"
    read ip
  done
fi

# Prompt for Username
echo "Enter the username (default:ubuntu)"
read user

# If username is not provided, use the default 'ubuntu'
if [ -z "$user" ]; then
  user="ubuntu"
fi



# Add the host to the config file
echo "Host $hostname" >> ~/.ssh/config
echo "  Hostname $ip" >> ~/.ssh/config
echo "  User $user" >> ~/.ssh/config
echo "" >> ~/.ssh/config

echo "Host $hostname added to ~/.ssh/config"
