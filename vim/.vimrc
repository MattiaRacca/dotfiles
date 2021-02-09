" No compatibility, thanks
set nocompatible

" Indentation and syntax
filetype plugin on
filetype indent on
set autoindent
syntax on

" Partial commands in the bar
set showcmd
" Hidden for buffers
set hidden

" Highlight search
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Stop certain movements from always going to the first character of a line.
set nostartofline

" Show cursorline
set cursorline

" Show line number in status line
set ruler
set laststatus=2
set noshowmode

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
" set cmdheight=2

" Use <F2> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F2>
nnoremap <F2> :set invpaste paste?<CR>

"------------------------------------------------------------
" Indentation
set shiftwidth=4
set softtabstop=4
set expandtab

"------------------------------------------------------------
" Mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" F3 to toggle between line numbering
nmap <silent> <F3> :exec &nu==&rnu? "se nu!" : "se rnu!"<CR>
set number

" Weird mappings on the arrow keys...
map Oc <C-Right>
map! Oc <C-Right>
map Od <C-Left>
map! Od <C-Left>
"------------------------------------------------------------
" Plugins with vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'sheerun/vim-wombat-scheme'
" Plug 'arcticicestudio/nord-vim'
Plug 'mboughaba/i3config.vim'
Plug 'tell-k/vim-autopep8'
call plug#end()

"------------------------------------------------------------
" lightline setup
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

"------------------------------------------------------------
" Colorscheme
colorscheme wombat

"------------------------------------------------------------
" Autopep8 on F8
let g:autopep8_disable_show_diff=1
autocmd FileType python noremap <buffer> <F8> :call Autopep8()<CR>

"------------------------------------------------------------
" Flag problematic whitespace (trailing and spaces before tabs)
" Note you get the same by doing let c_space_errors=1 but
" this rule really applys to everything.
highlight RedundantSpaces term=standout ctermbg=red guibg=red
" \ze sets end of match so only spaces highlighted
" match RedundantSpaces /\s\+$\| \+\ze\t/
function HighlightBadWhitespace()
    match RedundantSpaces /\s\+$\| \+\ze\t/
endfunction
" use :set list! to toggle visible whitespace on/off
set listchars=tab:>-,trail:.,extends:>
noremap <F9> :set list! <CR>
call HighlightBadWhitespace()

" automatic .launch highlighting (xml)
au BufNewFile,BufRead *.launch set filetype=xml
