" Vim syntax file
" Language:	Kooc
" Maintainer:	Pierre Wacrenier <pierre.wacrenier@epitech.eu>
" Last Change:	28-10-10

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
if version < 600
  so <sfile>:p:h/c.vim
else
  runtime! syntax/c.vim
  unlet b:current_syntax
endif
"
" Kooc extensions
syn match koocPrep		"@module\|@class\|@implementation\|@import\|@virtual\|@member"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink koocPrep		Statement
  delcommand HiLink
endif

let b:current_syntax = "cpp"

" vim: ts=8
