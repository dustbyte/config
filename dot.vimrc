"
" Plugins
"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-scripts/AutoComplPop'
" Plugin 'davidhalter/jedi-vim'
Plugin 'tpope/vim-surround'

call vundle#end()
filetype plugin indent on

"
" Settings
"

let mapleader="\<Space>"
let maplocalleader="\<Space>"

set nocompatible                        " vim defaults, not vi!
set hidden                              " allow editing multiple unsaved buffers
set more                                " the 'more' prompt
set cursorline
set autoread                            " watch for file changes by other programs
set visualbell t_vb=
set autochdir
set modelines=0                         " security

set noautowrite                         " don't automatically write on :next, etc
set wildmenu                            " : menu has tab completion, etc
set scrolloff=5                         " keep at least 5 lines above/below cursor
set sidescrolloff=5                     " keep at least 5 columns left/right of cursor
set history=300                         " remember the last 300 commands
set showcmd

set ignorecase
set hlsearch                            " enable search highlight globally
set incsearch                           " show matches as soon as possible
set showmatch                           " show matching brackets when typing

set cmdheight=1
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)[%y\:%{&ff}][%L]
set number

set wildmode=list,longest:full,full
set wildmenu

set mouse=a                             " mouse support in all modes
set mousehide                           " hide the mouse when typing text

set diffopt=filler,iwhite               " ignore all whitespace and sync

set completeopt=menuone,longest,preview
set backspace=eol,start,indent          " allow backspacing over indent, eol, & start
set undolevels=1000                     " number of forgivable mistakes
set updatecount=100                     " write swap file to disk every 100 chars
set complete=.,w,b,u,U,t,i,d            " do lots of scanning on tab completion
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo

set autoindent smartindent cindent      " turn on auto/smart indenting
set expandtab                           " use spaces, not tabs
set smarttab                            " make <tab> and <backspace> smarter
set shiftwidth=4                        " indents of 4
set cino=>4{2u0e2(0N-st0g0


"
" Bindings
"

nmap <Leader>ve :edit ~/.vimrc<cr>      " quickly edit this file
nmap <Leader>vs :source ~/.vimrc<cr>    " quickly source this file
nmap <Leader>sp :set paste!<cr>         " toggle paste mode

vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>P <ESC>"+P
nmap <Leader>p <ESC>"+p
nmap <Leader>o O<ESC>                   " append a line without moving the cursor

nmap <Leader>nh :nohlsearch<cr>

inoremap <Tab> <tab>
vnoremap <Tab> =

map <MouseMiddle> <ESC>"*p


""
"" Tab Control
""
map <ESC>1 1gt
map <ESC>2 2gt
map <ESC>3 3gt
map <ESC>4 4gt
map <ESC>5 5gt
map <ESC>6 6gt
map <ESC>7 7gt
map <ESC>8 8gt
map <ESC>9 9gt

nmap <C-l> <ESC>:tabnext<CR>
nmap <C-h> <ESC>:tabprev<CR>
map <C-t> :tabnew<CR>
map <C-d> :q<CR>


"
" Visual environment settings
"

if has('gui_running')
    colorscheme wombat256
    set guioptions-=T
    set guioptions-=t
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=m
    set guioptions-=b
    set guioptions+=c
else
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        au InsertEnter * set timeoutlen=0
        au InsertLeave * set timeoutlen=1000
    augroup END

    if $TERM =~ '.*256.*' || $TERM == "rxvt-unicode" || $TERM == "screen"
        set t_Co=256
        colorscheme wombat256
    else
        set t_Co=16
        colorscheme desert
    endif
endif


"
" Auto commands
"

if has('autocmd')
    syntax on

    " Jump to last cursor position according to viminfo
    autocmd BufReadPost *
                \ if line("'\"") > 0|
                \       if line("'\"") <= line("$")|
                \               exe("norm '\"")|
                \       else|
                \               exe "norm $"|
                \       endif|
                \ endif

    au BufRead,BufNewFile *.go set filetype=go
    au BufRead,BufNewFile *.wsgi set filetype=python
    au BufRead,BufNewFile Capfile set filetype=ruby

    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

    autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4

endif


"
" Functions
"

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

let g:jedi#popup_select_first=0
