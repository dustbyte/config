" Vim syntax file
" Language:	CodeWorker
" Maintainer:	Pierre Wacrenier <pierre.wacrenier@epitech.eu>
" Last Change:	2010 september 30

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

"CodeWorker extensions
syn keyword cwStatements	foreach in function declare
syn keyword cwType		local global insert ref localref pushItem setall merge
syn match   cwParam		": \zs.\{-}\ze[,)]"
syn match   cwDirective		"#\<\I*"

" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cwStatements		Statement
  HiLink cwType			Type
  HiLink cwParam		cwType
  HiLink cwDirective		Number

  delcommand HiLink
endif

let b:current_syntax = "cw"

" vim: ts=8
