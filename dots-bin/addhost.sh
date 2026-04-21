#!/bin/bash

# Ask for environment type
echo "Select environment (1:slurm/2:oke):"
read env

if [[ "$env" == "oke" ]] || [[ "$env" -eq 2 ]]; then
  echo "Adding OKE stack Host"
  # Ensure ~/.ssh exists
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  # Ensure main config exists
  if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
  fi

  # Ensure oke.conf exists
  if [ ! -f ~/.ssh/oke.conf ]; then
    touch ~/.ssh/oke.conf
    chmod 600 ~/.ssh/oke.conf
  fi

  # Ensure oke.conf is included
  if ! grep -q "Include ~/.ssh/oke.conf" ~/.ssh/config; then
    echo "Include ~/.ssh/oke.conf" >> ~/.ssh/config
  fi

  # Prompt for hostname
  echo "Enter the hostname"
  read hostname

  while [ -z "$hostname" ]; do
    echo "Nothing entered"
    echo "Please input a hostname"
    read hostname
  done

  # Check if host already exists in oke.conf
  while grep -q "Host $hostname" ~/.ssh/oke.conf; do
    echo "Host $hostname already exists in ~/.ssh/oke.conf."
    echo "Please input a different hostname"
    read hostname
  done

  # Target private IP
  echo "Enter the private IP Address"
  read ip

  while ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
    echo "Invalid IP address. Please enter a valid IP address:"
    read ip
  done

  # Bastion / jump host
  echo "Enter the bastion (jump host) IP"
  read bastion

  while ! [[ $bastion =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
    echo "Invalid IP address. Please enter a valid IP address:"
    read bastion
  done

  # Username
  echo "Enter the username (default: ubuntu)"
  read user
  if [ -z "$user" ]; then
    user="ubuntu"
  fi

  # Write config using ProxyJump
  {
    echo "Host $hostname"
    echo "    HostName $ip"
    echo "    User $user"
    echo "    ProxyJump $user@$bastion"
    echo ""
    echo "Host $hostname-bastion"
    echo "    HostName $bastion"
    echo "    User $user"
    echo ""
  } >> ~/.ssh/oke.conf

  echo "Host $hostname and $hostname-bastion added to ~/.ssh/oke.conf"

elif [[ "$env" == "slurm" ]] || [[ "$env" -eq 1 ]]; then

  echo "Adding SLURM stack Host"
  if [ ! -f ~/.ssh/config ]; then
    touch ~/.ssh/config
    chmod 600 ~/.ssh/config
  fi

  echo "Enter the hostname"
  read hostname

  while [ -v $hostname ] ; do
    echo "Nothing entered"
    echo "Please input a hostname"
    read hostname
  done

  while grep -q "$hostname" ~/.ssh/config; do
    echo "Host $hostname already exists in ~/.ssh/config."
    echo "Please input a different hostname"
    read hostname
  done

  echo "Enter the IP Address"
  read ip

  if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Invalid IP address. Please enter a valid IP address in the format XXX.XXX.XXX.XXX:"
    read ip
    while ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; do
      echo "Invalid IP address. Please enter a valid IP address in the format XXX.XXX.XXX.XXX:"
      read ip
    done
  fi

  echo "Enter the username (default:ubuntu)"
  read user

  if [ -z "$user" ]; then
    user="ubuntu"
  fi

  echo "Host $hostname" >> ~/.ssh/config
  echo "  Hostname $ip" >> ~/.ssh/config
  echo "  User $user" >> ~/.ssh/config
  echo "" >> ~/.ssh/config

  echo "Host $hostname added to ~/.ssh/config"

else
  echo "Invalid option. Please run the script again and choose 'slurm' or 'oke'."
fi
