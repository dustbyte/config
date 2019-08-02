"
" Plugins
"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.Vim
call vundle#begin()

Plugin 'gmarik/Vundle.Vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-scripts/AutoComplPop'
Plugin 'tpope/vim-surround'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'fatih/vim-go'
Plugin 'SirVer/ultisnips'
Plugin 'davidhalter/jedi-vim'
Plugin 'slim-template/vim-slim.git'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'scrooloose/nerdtree'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-endwise'
Plugin 'vim-scripts/closetag.vim'
Plugin 'samsaga2/vim-z80'
Plugin 'hashivim/vim-terraform'
Plugin 'godlygeek/tabular'
Plugin 'alfredodeza/pytest.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'rhysd/vim-crystal'
Plugin 'keith/swift.vim'

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
set smartcase
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

set completeopt=menuone,longest
set backspace=eol,start,indent          " allow backspacing over indent, eol, & start
set undolevels=1000                     " number of forgivable mistakes
set updatecount=100                     " write swap file to disk every 100 chars
set complete=.,w,b,u,U,t,i,d            " do lots of scanning on tab completion
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo

set autoindent smartindent cindent      " turn on auto/smart indenting
set expandtab                           " use spaces, not tabs
set smarttab                            " make <tab> and <backspace> smarter
set shiftwidth=4                        " indents of 4
set cino=>4{2u0(0,W4,m1N-st0g0


"
" Bindings
"

nmap <Leader>ve :edit ~/.vimrc<cr>      " quickly edit this file
nmap <Leader>vs :source ~/.vimrc<cr>    " quickly source this file
nmap <Leader>sp :set paste!<cr>         " toggle paste mode

noremap <Leader>f :call IndentWholeFile()<cr>

vmap <Leader>y "+y
vmap <Leader>Y "*y
vmap <Leader>d "+d
vmap <Leader>D "*d
nmap <Leader>P <ESC>"+P
nmap <Leader>p <ESC>"+p
noremap <LocalLeader>o :call DownOneLine()<cr>
map <Leader>ld "_d
map <Leader>lp "_dP

map <Leader>t :NERDTreeToggle<cr>
map <Leader>l :NERDTreeFind<cr>

nmap <Leader>nh :nohlsearch<cr>
map <Leader><Tab> :Tab /=<cr>

"inoremap <Tab> <tab>
"vnoremap <Tab> =

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
    au BufRead,BufNewFile *xonshrc set filetype=python
    au BufRead,BufNewFile Capfile set filetype=ruby
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile *.slim set filetype=slim
    au BufRead,BufNewFile nginx.conf* set filetype=conf

    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

    autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4
    autocmd FileType python setlocal completeopt-=preview
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2
    autocmd FileType sh setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

    "
    " Python
    "

    au FileType python nmap <Leader>1 :Pytest function<cr>
    au FileType python nmap <Leader>2 :Pytest file<cr>
    au FileType python nmap <Leader>3 :Pytest method<cr>
    au FileType python nmap <Leader>4 :Pytest class<cr>

    "
    " Go
    "

    autocmd FileType go setlocal tabstop=8 shiftwidth=8 noexpandtab

    au FileType go nmap <leader>gr <Plug>(go-run)
    au FileType go nmap <leader>gb <Plug>(go-build)
    au FileType go nmap <leader>gt <Plug>(go-test)
    au FileType go nmap <leader>gf <Plug>(go-test-func)
    au FileType go nmap <leader>gc <Plug>(go-coverage)
    au FileType go nmap <Leader>gd <Plug>(go-def-vertical)
    au FileType go nmap <Leader>gD <Plug>(go-doc-vertical)
    au FileType go nmap <Leader>gi <Plug>(go-implements)
    au FileType go nmap <Leader>gI <Plug>(go-info)
    au FileType go nmap <Leader>gR <Plug>(go-rename)

    let g:go_fmt_command = "goimports"
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

fun! IndentWholeFile()
    let l = line(".")
    let c = col(".")
    :normal gg=G
    call cursor(l, c)
endfun

fun! DownOneLine()
    :execute "normal! I\<cr>\<esc>k0D"
endfun

let g:jedi#popup_select_first=0
let g:closetag_filenames = "*.html"
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

let g:NERDCustomDelimiters = {
            \ 'dnsmasq': { 'left': '#' }
            \}

let local_file=$HOME.'/.vimrc_local'
if filereadable(local_file)
    :execute 'source '.local_file
endif
