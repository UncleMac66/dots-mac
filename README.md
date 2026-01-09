# mac dotfiles

This repository contains configuration files (“dotfiles”) for my Linux setup, managed using [GNU Stow](https://www.gnu.org/software/stow/) and some helper scripts.

This is mostly for me to remember how to set up new/old laptops and keep my dots somewhat consistent. Feel free to use it if it helps at all.

FYI: A lot of things are specific to my environment and may not work well with others.

## Setup

1. **Clone this repository:**

   ```sh
   git clone https://github.com/unclemac66/dots-machrome.git ~/dots-machrome
   ```

2. ** Install packages:**
   This also install the Hack Nerd Font
   ```sh
   installpkgs.sh
   ```
3. **Deploy dotfiles:**  
   The `dots-bin` folder is added to PATH by `.bashrc`, so you can run setup scripts from anywhere.

   - To symlink/update configs, simply run:
     ```sh
     updatedots.sh
     ```

   - If you prefer, you can use GNU Stow directly:
     ```sh
     cd dots-mac
     stow .  
     ```


## What's included

- Configs for bash, tmux, vim, git, kitty, hyprland, and others
- Helper scripts for setup, package installation, and SSH configuration
- Designed for easy management and portability. I've found most dot managers to be too complex. Stow and this helper script works well for me


