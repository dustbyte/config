" ---------------------------------------------------------------------------
" first the disabled features due to security concerns
set modelines=0         " no modelines [http://www.guninski.com/vim1.html]

" ---------------------------------------------------------------------------
" configure other scripts

let c_no_curly_error = 1

" ---------------------------------------------------------------------------
" operational settings
let maplocalleader=','          " all my macros start with ,

set nocompatible                " vim defaults, not vi!
filetype plugin on 		" enable plugins
syntax on                       " syntax on
filetype on                     " automatic file type detection

set hidden                      " allow editing multiple unsaved buffers
set more                        " the 'more' prompt
set cursorline
set autoread                    " watch for file changes by other programs
set visualbell t_vb=
set autochdir

set noautowrite                 " don't automatically write on :next, etc
set wildmenu                    " : menu has tab completion, etc
set scrolloff=5                 " keep at least 5 lines above/below cursor
set sidescrolloff=5             " keep at least 5 columns left/right of cursor
set history=300                 " remember the last 300 commands
set showcmd

" ---------------------------------------------------------------------------
" meta
map <LocalLeader>ce :edit ~/.vimrc<cr>          " quickly edit this file
map <LocalLeader>cs :source ~/.vimrc<cr>        " quickly source this file
map <LocalLeader>o  O<ESC>			" append a line without moving the curso

inoremap <Tab> <tab>
vnoremap <Tab> =

" ---------------------------------------------------------------------------
" window spacing
set cmdheight=1                 " make command line two lines high
set ruler                       " show the line number on bar
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)[%y\:%{&ff}][%L]
set number                      " show line number on each line

set wildmode=list,longest:full,full
set wildmenu

" ---------------------------------------------------------------------------
" mouse settings
set mouse=a                     " mouse support in all modes
set mousehide                   " hide the mouse when typing text

" ,p and shift-insert will paste the X buffer, even on the command line
nmap <LocalLeader>p i<S-MiddleMouse><ESC>
imap <S-Insert> <S-MiddleMouse>
cmap <S-Insert> <S-MiddleMouse>

" this makes the mouse paste a block of text without formatting it
" (good for code)
map <MouseMiddle> <esc>"*p

" ---------------------------------------------------------------------------
" global editing settings
set autoindent smartindent cindent     " turn on auto/smart indenting

set completeopt=menuone,longest,preview

set expandtab                 " use spaces, not tabs
set tabstop=4                 " tabstops of 2
set softtabstop=4

set backspace=eol,start,indent  " allow backspacing over indent, eol, & start
set undolevels=1000             " number of forgivable mistakes
set updatecount=100             " write swap file to disk every 100 chars
set complete=.,w,b,u,U,t,i,d    " do lots of scanning on tab completion
set viminfo=%100,'100,/100,h,\"500,:100,n~/.viminfo
"set textwidth=80

set smarttab                    " make <tab> and <backspace> smarter
set shiftwidth=4                " indents of 2
set cino=>4{2u0e2(0N-st0g0

" ---------------------------------------------------------------------------
" searching...
set hlsearch                   " enable search highlight globally
set incsearch                  " show matches as soon as possible
set showmatch                  " show matching brackets when typing
" disable last one highlight
nmap <LocalLeader>nh :nohlsearch<cr>

set diffopt=filler,iwhite       " ignore all whitespace and sync

" ---------------------------------------------------------------------------
" some useful mappings

" disable yankring
let loaded_yankring = 22

" Y yanks from cursor to $
map Y y$
" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>
" correct type-o's on exit
nmap q: :q

" Delete trailing whitespaces

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" ---------------------------------------------------------------------------
" setup for the visual environment
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

    if !has("unix")
        set guifont=Consolas:h10
    else
        set guifont=Dejavu\ Sans\ Mono\ 8
    endif
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

" ---------------------------------------------------------------------------
" auto load extensions for different file types
if has('autocmd')
  filetype plugin indent on
  syntax on

  " jump to last line edited in a given file (based on .viminfo)
  "autocmd BufReadPost *
  "       \ if !&diff && line("'\"") > 0 && line("'\"") <= line("$") |
  "       \       exe "normal g`\"" |
  "       \ endif
  autocmd BufReadPost *
          \ if line("'\"") > 0|
          \       if line("'\"") <= line("$")|
          \               exe("norm '\"")|
          \       else|
          \               exe "norm $"|
          \       endif|
          \ endif

  " improve legibility
  au BufRead quickfix setlocal nobuflisted wrap number

  au BufRead,BufNewFile *.go set filetype=go
  au BufRead,BufNewFile *.wsgi set filetype=python
  au BufRead,BufNewFile Capfile set filetype=ruby

  " configure various extenssions
  let git_diff_spawn_mode=2

  autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4

endif

" ===========================================================================


" ---------------------------------------------------------------------------
"  configure calendar
let g:calendar_monday = 1

nmap <LocalLeader>o O <Esc>

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

call pathogen#infect()

let g:jedi#popup_on_dot = 0
let g:jedi#use_tabs_not_buffers = 0

" Annoyance
let g:netrw_dirhistmax = 0

" Tab Control
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
