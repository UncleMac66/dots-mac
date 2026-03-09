""""""""""""""""""""""""""""""""""""""
" Mac's Vim config                v1.1
""""""""""""""""""""""""""""""""""""""
" Changelog
" - v1.0   initial config
" - v1.1   add vim-which-key
"          add sudo and remove blank lines funcs
"
"
"
"
"""""""""""""""""""""""""""""""""""""
" Configure leader and mappings
""""""""""""""""""""""""""""""""""""""
let mapleader = " "

" Saving
nnoremap <leader>w :w<CR>
nnoremap <leader>ww :wa<CR>:echo "All Files Saved!" <CR>
nnoremap <leader>wq :wq<CR>

" Quitting
nnoremap <silent>  <leader>qq :qa!<CR>
nnoremap <silent>  <leader>x :q!<CR>

" Move cursor to next window by double spacing
nnoremap <silent>  <leader><leader> <C-w>w

" toggle line numbers
nnoremap <leader>nn :call ToggleNumber()<CR>

" new tabs
nnoremap <leader>t :tabnew<CR>  " Open new tab

" source .vimrc
nnoremap <leader>r :source ~/.vimrc<CR>:echo "Config Reloaded!" <CR>

" custom calls for packages
nnoremap <leader>f :NERDTreeToggle<CR>
tnoremap <silent> <C-H> <C-\><C-n>:FloatermNew<CR>
tnoremap <silent> <C-J> <C-\><C-n>:FloatermNext<CR>
tnoremap <silent> <C-K> <C-\><C-n>:FloatermPrev<CR>
tnoremap <silent> <C-X> <C-\><C-n>:FloatermKill<CR>
tnoremap <silent> <C-L> <C-\><C-n>:FloatermUpdate --position=bottomright<CR>
tnoremap <silent> <C-L><C-L> <C-\><C-n>:FloatermUpdate --position=topright<CR>
nnoremap <silent> <C-Q> :FloatermToggle<CR>
tnoremap <silent> <C-Q> <C-\><C-n>:FloatermToggle<CR>

" Toggle comment (line or selection)
nnoremap <Leader>c  <Plug>NERDCommenterToggle
vnoremap <Leader>c  <Plug>NERDCommenterToggle

" Enable filetype plugins (required for correct commentstring)
filetype plugin on

""""""""""""""""""""""""""""""""""""""
" Load/Configure Packages
"""""""""""""""""""""""r""""""""""""""
" nerdtree
packadd! nerdtree

" load nerdtree by default when no file is given to vim
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" NERD Commenter settings
let g:NERDTrimTrailingWhitespace = 1       " trim trailing whitespace when uncommenting
let g:NERDSpaceDelims = 1                  " add a space after delimiters: // comment
let g:NERDDefaultAlign = 'left'            " align left
let g:NERDCompactSexyComs = 1              " compact block comments

if isdirectory(expand('~/.vim/pack/code/start/nerdcommenter/doc'))
exe 'helptags' expand('~/.vim/pack/code/start/nerdcommenter/doc')
endif

" Floaterm
" Set floaterm window's background to black
" hi Floaterm guibg=black
" Set floating window border line color to cyan, and background to orange
" hi FloatermBorder guibg=orange guifg=cyan

""""""""""""""""""""""""""""""""""""""
" whichkey setup and mappings/dictionary
""""""""""""""""""""""""""""""""""""""

set timeoutlen=500
packadd! vim-which-key

nnoremap <silent> <leader> :WhichKey '<Space>' <CR>

" which-key REGISTRATIONS (separate calls for prefixes/modes)
" initialize which-key maps per prefix/mode
let g:which_key_map      = {}

" Leader (space) - Normal/Visual mode groups
let g:which_key_map['w'] = {'name' : '+Save'}
let g:which_key_map['ww'] = 'save all'
let g:which_key_map['wq'] = 'save & quit'
let g:which_key_map['q']  = 'quit!'
let g:which_key_map['qq']  = 'quit all!'
let g:which_key_map['x']  = 'quit!'
let g:which_key_map['nn'] = 'toggle numberlines'
let g:which_key_map['t']  = 'new tab'
let g:which_key_map['r']  = 'reload config'
let g:which_key_map['f']  = 'NERDTree'
let g:which_key_map['sw'] = 'Save with sudo'
let g:which_key_map['tb'] = 'Toggle blank lines'
call which_key#register(' ', 'g:which_key_map', 'n')  " prefix, map-var, mode=n


""""""""""""""""""""""""""""""""""""""
" Set theme
""""""""""""""""""""""""""""""""""""""
set termguicolors
try
colorscheme jellybeans
let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}
if has('termguicolors') && &termguicolors
let g:jellybeans_overrides['background']['guibg'] = 'none'
endif
catch
" if jellybeans isn't available so just use on okay builtin theme
colorscheme desert
:echo "Jellybeans not found or configured! Defaulting to to builtin desert colorscheme"<CR>
endtry

""""""""""""""""""""""""""""""""""""""
" Stylistic and other settings
""""""""""""""""""""""""""""""""""""""
syntax on
set mouse= " disable mouse
set showtabline=2
set relativenumber
set number
set cursorline
set magic
set smartcase
set incsearch
set matchpairs=(:),{:},[:],":",':'

""""""""""""""""""""""""""""""""""""""
" wildmenu settings
""""""""""""""""""""""""""""""""""""""
set wildignorecase
set wildmenu

""""""""""""""""""""""""""""""""""""""
" Tabbing mapped to H and L
""""""""""""""""""""""""""""""""""""""
nnoremap H gT
nnoremap L gt

""""""""""""""""""""""""""""""""""""""
" Use tabs as spaces by default
""""""""""""""""""""""""""""""""""""""
set tabstop=2     " Size of a hard tabstop (ts).
set shiftwidth=2  " Size of an indentation (sw).
set expandtab     " Always uses spaces instead of tab characters (et).
set softtabstop=0 " Number of spaces a <Tab> counts for. When 0, feature is off (sts).
set autoindent    " Copy indent from current line when starting a new line.
set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).

""""""""""""""""""""""""""""""""""""""
" Functions **************************
""""""""""""""""""""""""""""""""""""""
" Function to remove all whitespace
let g:blank_lines_removed = 0

function! ToggleBlankLines()
if g:blank_lines_removed == 0
    :g/^$/d
    let g:blank_lines_removed = 1
    echo "Blank lines removed"
else
    :undo
    let g:blank_lines_removed = 0
    echo "Blank lines restored"
endif
endfunction

command! ToggleBlankLines call ToggleBlankLines()
nnoremap <leader>tb :call ToggleBlankLines()<CR>

" Function to write when you need sudo but forget to open vim with sudo
function! SudoWrite()
:w !sudo tee % > /dev/null
endfunction

command! SudoWrite call SudoWrite()
nnoremap <leader>sw :call SudoWrite()<CR>


" Function to switch back to spaces if needed
function! UseSpaces()
  set tabstop=2     " Size of a hard tabstop (ts).
  set shiftwidth=2  " Size of an indentation (sw).
  set expandtab     " Always uses spaces instead of tab characters (et).
  set softtabstop=0 " Number of spaces a <Tab> counts for. When 0, feature is off (sts).
  set autoindent    " Copy indent from current line when starting a new line.
  set smarttab      " Inserts blanks on a <Tab> key (as per sw, ts and sts).
  echo "Spaces for tabs enabled"
endfunction

" Function to switch back to tabs as actual tabs if needed
function! UseTabs()
  set tabstop=4     " Size of a hard tabstop (ts).
  set shiftwidth=4  " Size of an indentation (sw).
  set noexpandtab   " Always uses tabs instead of space characters (noet).
  set autoindent    " Copy indent from current line when starting a new line (ai).
  echo "Actual tabs enabled"
endfunction

" Function to toggle line numbers
function! ToggleNumber()
  if &number
    set nonumber
    set norelativenumber
    echo "Line numbers disabled"
  else
    set number
    set relativenumber
    echo "Line numbers enabled with relative numbers"
  endif
endfunction
