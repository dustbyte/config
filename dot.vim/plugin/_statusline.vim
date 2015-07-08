"
" status line

set laststatus=2
if has('statusline')
  "set statusline=%-(%F\ [%y\:%{&ff}]\ %m%r%h%w%)%=%([dec=\%03.3b][hex=\%02.2B]\ [l=%04l][c=%03c,%03v]\ [%p%%][%Llines]%)
  " se contenter des couleurs normales
  if version >= 700 && $TERM =~ '^xterm'
    au InsertEnter * hi StatusLine ctermbg=64
    " depend en fait du theme
    au InsertLeave * hi StatusLine ctermbg=237
  endif
endif
