#!/bin/bash

if ! command -v lsb_release >/dev/null 2>&1; then
  echo "lsb_release not found; cannot detect distro." >&2
  exit 1
fi
ID="$(lsb_release -is 2>/dev/null || true)"
if [[ "${ID,,}" != "debian" && "${ID,,}" != "ubuntu" ]]; then
  echo "This script supports Debian/Ubuntu only. Detected: $ID" >&2
  exit 1
fi

if [ "$(basename "$PWD")" != "dots-mac" ]; then 
  cd ~/dots-mac
  if [[ "$?" -gt 0 ]]; then
    echo -e "Can't find dots-mac directory!"
    exit 1
  fi
fi


# Define the font directory and the font file name
FONT_DIR="$HOME/.local/share/fonts"
FONT_NAME="Hack Nerd Font.ttf"
FONT_PATH="$FONT_DIR/$FONT_NAME"

# Function to install Hack Nerd Font
install_font() {
    say "Installing Hack Nerd Font..."
    
    # Create font directory if it doesn't exist
    mkdir -p "$FONT_DIR"
    
    # Download the font
    curl -L -o "$FONT_PATH" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip"
    
    # Unzip the font
    unzip -o "$FONT_PATH" -d "$FONT_DIR"
    
    # Clear font cache
    fc-cache -f -v
    
    say "Hack Nerd Font installed successfully!"
}

say() {
    printf "%s\n" "$1"
}

# apt update
sudo apt update

# pkgs stored in installpkgs
# apt install all pkgs in list
sudo xargs -a installpkgs apt install -y
say "Done installing/updating package list..."

# check if hack nerd font exists and install if not
if fc-list | grep -i "Hack Nerd Font"; then
    say "Hack Nerd Font already Installed"
else
    install_font
fi

say "installing ocicli..."
updateocicli.sh --accept-all-defaults 








