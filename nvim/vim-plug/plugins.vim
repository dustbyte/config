" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('$HOME/.config/nvim/autoload/plugged')

    Plug 'sheerun/vim-polyglot'
    Plug 'scrooloose/NERDTree'
    Plug 'kien/ctrlp.vim'
    Plug 'tpope/vim-fugitive'
    Plug 'scrooloose/nerdcommenter'
    Plug 'jiangmiao/auto-pairs'
    Plug 'tpope/vim-surround'
    "Plug 'fatih/vim-go'
    "Plug 'vim-ruby/vim-ruby'
    "Plug 'tpope/vim-rails'
    "Plug 'kchmck/vim-coffee-script'
    Plug 'samsaga2/vim-z80'
    "Plug 'hashivim/vim-terraform'
    Plug 'alfredodeza/pytest.vim'
    "Plug 'rust-lang/rust.vim'
    "Plug 'rhysd/vim-crystal'
    "Plug 'keith/swift.vim'
    "Plug 'elixir-editors/vim-elixir'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'rodjek/vim-puppet'

call plug#end()
