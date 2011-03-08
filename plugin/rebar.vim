" Vim global plugin for Rebar
" Last Change:  2010 August 02
" Name:         Rebar
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" License:      This plugin is licensed under the MIT license.

if exists("loaded_rebar")
  finish
endif
let loaded_rebar = 1

let cpoOriginal = &cpo
set cpo&vim

augroup rebarPlugin
  autocmd!
  autocmd QuickfixCmdPost make* call rebar#ConvertErrorMessages()
  autocmd BufNewFile,BufRead Gemfile call rebar#SetupBufCommands()
  autocmd BufEnter * call <SID>EnableRebarPlugin()
augroup END

function s:EnableRebarPlugin()
  let rebarCfgPath = findfile("rebar.config", getcwd())
  if filereadable(rebarCfgPath)
    call rebar#SetupBufCommands()
    silent doautocmd rebarPlugin
    " TODO: Add subcommand variable population
    call rebar#SetupSubcommands()
  endif
endfunction

call s:EnableRebarPlugin()

" Default key map
if !hasmapto('<Plug>Rebar')
    map <unique> <Leader>R <Plug>Rebar
endif

let &cpo = cpoOriginal
unlet cpoOriginal
