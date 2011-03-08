" File:         rebar.vim
" Description:  A NERDTree plugin to execute the rebar project files inside Vim
" Maintainer:   Susan Potter <meNOSPAM@susanpotter.net>
" Last Change:  2010-08-25
" Name:         rebar
" Version:      0.1
" License:      Charityware license


" Adds a submenu to the NERD tree menu if a rebar Gemfile exists in the root.
if exists("g:loaded_nerdtree_rebar_menu")
  finish
endif
let g:loaded_nerdtree_rebar_menu = 1

" {{{ Local functions 
function s:RebarConfPath()
  let rebarConfPath = fnamemodify(b:NERDTreeRoot.path.str(), ":p") . "/rebar.config"
  return rebarConfPath
endfunction

function s:SetuprebarSubmenu()
  call NERDTreeAddMenuSeparator()
  let rebarSubmenu = NERDTreeAddSubmenu({
    \ 'text': '(R)ebar commands',
    \ 'isActiveCallback': 'NERDTreeRebarMenuEnabled',
    \ 'shortcut': 'R' })
  call NERDTreeAddMenuItem({
    \ 'text': 'Rebar (c)ompile', 
    \ 'shortcut': 'c',
    \ 'callback': 'NERDTreeRebarCompile',
    \ 'parent': l:rebarSubmenu })
  call NERDTreeAddMenuItem({
    \ 'text': 'Rebar (b)uild PLT', 
    \ 'shortcut': 'b',
    \ 'callback': 'NERDTreeRebarBuildPLT',
    \ 'parent': l:rebarSubmenu })
  call NERDTreeAddMenuItem({
    \ 'text': 'Rebar (d)ialyze', 
    \ 'shortcut': 'd',
    \ 'callback': 'NERDTreeRebarDialyze',
    \ 'parent': l:rebarSubmenu })
  call NERDTreeAddMenuItem({
    \ 'text': 'Rebar (x)ref', 
    \ 'shortcut': 'x',
    \ 'callback': 'NERDTreeRebarXref',
    \ 'parent': l:rebarSubmenu })
  call NERDTreeAddMenuItem({
    \ 'text': 'Rebar (t)est', 
    \ 'shortcut': 't',
    \ 'callback': 'NERDTreeRebarTest',
    \ 'parent': l:rebarSubmenu })
endfunction
" }}}

" {{{ Public interface 
function NERDTreeRebarMenuEnabled()
  return filereadable(s:RebarConfPath())
endfunction

function NERDTreeRebarCompile()
  call rebar#Execute('compile')
endfunction

function NERDTreeRebarBuildPLT()
  call rebar#Execute('build-plt')
endfunction

function NERDTreeRebarDialyze()
  call rebar#Execute('dialyze')
endfunction

function NERDTreeRebarXref()
  call rebar#Execute('xref')
endfunction

function NERDTreeRebarTest()
  call rebar#Execute('ct')
endfunction

" }}}

" {{{ Execution
call s:SetuprebarSubmenu()
" }}}
