" Vim Rebar autoload
" Name:		      Rebar
" Maintainer:   Susan Potter <me [at] susanpotter [dot] net>
" Last Change:  10 Nov 2010

" Public functions

" Retrieve error format for a specific subcommand
function rebar#ErrorFormatFor(subCmd)
  let subCmd = a:subCmd
  let errorFormats = {}
  let errorFormats['compile']="%f:%l: %m"

  for cmd in g:rebarSubcommands
    if !has_key(errorFormats, cmd)
      let errorFormats[cmd] = ""
    endif
  endfor

  return errorFormats[subCmd]
endfunction

" Execute the rebar command
function rebar#Execute(subCmd)
  let subCmd = a:subCmd
  let makeprgOriginal = &l:makeprg
  let errorformatOriginal = &l:errorformat
  try
    let &l:makeprg = 'rebar'
    let &l:errorformat = rebar#ErrorFormatFor(subCmd)
    exec 'make '.subCmd
    copen
  catch /^Vim(\a\+):E42:/
    " do nothing, because there are no errors...maybe output SUCCESS or
    " something?
    echohl '":Rebar '.subCmd.'" completed without errors'
  finally
    let &l:errorformat = errorformatOriginal
    let &l:makeprg = makeprgOriginal
  endtry
endfunction

" Converts error message format to something more readable
function rebar#ConvertErrorMessages()
  if &l:makeprg =~ 'rebar'
    let quickfixList = getqflist()
    " Only show valid quickfix lines in output
    call filter(quickfixList, 'v:val.valid')
    " filter to remove unnecessary quickfix line output
    call filter(quickfixList, 'v:val.text !~ "Warning:"')
    call setqflist(quickfixList)
  endif
endfunction

" Auto-complete all available subcommands for rebar 
function rebar#AutoCompleteSubcommands(ArgLead, CmdLine, CursorPos)
  let matches = copy(g:rebarSubcommands)
  let condition = 'v:val =~ "^' . a:ArgLead . '"'
  call filter(matches, condition)
  return matches
endfunction

function rebar#SetupSubcommands()
  if !exists('g:rebarSubcommands')
    try
      let lines = split(system("rebar -c"), "\n")
    endtry
    if v:shell_error != 0
      return []
    endif
    call map(lines, 'matchstr(v:val, "[a-zA-Z0-9-]*")')
    call filter(lines, 'v:val != ""')
    let g:rebarSubcommands = lines
  endif
endfunction

" Setup buffer commands
function rebar#SetupBufCommands()
  command! -buffer -nargs=1 -complete=customlist,rebar#AutoCompleteSubcommands Rebar call rebar#Execute(<q-args>)
endfunction

" vim: ft=vim
