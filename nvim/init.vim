set nocompatible
filetype off

source $HOME/.config/nvim/vim-plug/plugins.vim

"
" Settings
"

let mapleader="\<Space>"
let maplocalleader="\<Space>"

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
set foldlevel=0
set nofoldenable

"
" Bindings
"

nmap <Leader>ve :edit ~/.config/nvim/init.vim<cr>      " quickly edit this file
nmap <Leader>vle :edit ~/.config/nvim/nvim_local.vim<cr>      " quickly edit local file
nmap <Leader>vp :edit ~/.config/nvim/vim-plug/plugins.vim <cr>    " quickly source this file
nmap <Leader>vc :edit ~/.config/nvim/coc-settings.json <cr>
nmap <Leader>vs :source ~/.config/nvim/init.vim<cr>
nmap <Leader>sp :set paste!<cr>         " toggle paste mode

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
    au BufRead,BufNewFile *.asm set filetype=asm
    au BufRead,BufNewFile *.inc set filetype=asm
    au BufRead,BufNewFile *.zig set filetype=zig
    au BufRead,BufNewFile *.zir set filetype=zir
    au BufRead,BufNewFile *.wsgi set filetype=python
    au BufRead,BufNewFile *xonshrc set filetype=python
    au BufRead,BufNewFile Capfile set filetype=ruby
    au BufRead,BufNewFile Vagrantfile set filetype=ruby
    au BufRead,BufNewFile *.slim set filetype=slim
    au BufRead,BufNewFile nginx.conf* set filetype=conf
    au BufRead,BufNewFile *.pcl normal zR
    au BufRead,BufNewFile *.asm set filetype=rgbds
    au BufRead,BufNewFile hardware.inc set filetype=rgbds

    autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

    autocmd FileType python setlocal expandtab tabstop=4 softtabstop=4
    autocmd FileType python setlocal completeopt-=preview
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2
    autocmd FileType sh setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType pcl setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2

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

    "
    " Rust
    "
    au FileType rust nmap <Leader>1 :RustTest<cr>
    au FileType rust nmap <Leader>2 :RustTest!<cr>

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

"let local_file=expand('~/.conf/nvim/nvim_local.vim')
"if filereadable(local_file)
    ":execute 'source' local_file
"endif

" Validate completion with enter instead of C-Y

inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

" Coc

function! SplitIfNotOpen(...)
    " ref https://github.com/neoclide/coc.nvim/issues/586#issuecomment-701711012
    let fname = a:1
    let call = ''
    if a:0 == 2
        let fname = a:2
        let call = a:1
    endif
    let bufnum=bufnr(expand(fname))
    let winnum=bufwinnr(bufnum)
    if winnum != -1
        " Jump to existing split
        exe winnum . "wincmd w"
    else
        " Make new split as usual
        exe "vsplit " . fname
    endif
    " Execute the cursor movement command
    exe call
endfunction

command! -nargs=+ CocSplitIfNotOpen :call SplitIfNotOpen(<f-args>)

let g:coc_user_config = {}
let g:coc_user_config['coc.preferences.jumpCommand'] = ':CocSplitIfNotOpen'

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

nmap <leader>jd :call CocActionAsync('jumpDefinition')<cr>
nmap <leader>jr :call CocActionAsync('jumpReferences')<cr>
nmap <leader>rs :call CocActionAsync('rename')<cr>
nmap <leader>go :execute 'silent!!og' @% line(".")<cr>

au FileType go nmap <leader>ctt :CocCommand go.test.toggle<cr>

let g:NERDCustomDelimiters = { 'rgbds' : { 'left': ';', 'right': '' } }

" FZF

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number -- '.shellescape(<q-args>),
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

nmap <Leader>f :GGrep<cr>

nmap <Leader>gb :Git blame<cr>

" Maximize window management
nnoremap <C-W>m <C-W>\| <C-W>_
