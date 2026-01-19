# aliases for neovim
alias vi='vim'

# alias for console history w/ fzf
alias history='cat ~/.bash_history | fzf | bash'

# Alias for cp
alias cp='cp -v -i'

# alias for cmatrix
alias cm='cmatrix -sb'

# alias for cd to previous dir
alias cdb='cd "$OLDPWD"'
alias cdd='cd "$OLDPWD"'

# Update packages
alias aptup='sudo apt update && sudo apt upgrade -y'

