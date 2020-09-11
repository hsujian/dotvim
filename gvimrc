" This is Dejian's .gvimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:

set guioptions-=r
set guioptions-=L
set switchbuf=usetab,newtab
set mousehide

augroup gvimrcEx
  au!

  if !empty($MYGVIMRC)
    au BufWritePost .gvimrc,_gvimrc,gvimrc so $MYGVIMRC
  endif
augroup END

au FocusGained * set guitablabel=%M%N\ %.50f

if has("gui_macvim")
  "set guifont=Monaco:h16
  set guifont=Cascadia\ Code\ PL:h16
  nnoremap <D-1> 1gt
  imap <D-1> <C-o><D-1>
  nnoremap <D-2> 2gt
  imap <D-2> <C-o><D-2>
  nnoremap <D-3> 3gt
  imap <D-3> <C-o><D-3>
  nnoremap <D-4> 4gt
  imap <D-4> <C-o><D-4>
  nnoremap <D-5> 5gt
  imap <D-5> <C-o><D-5>
  nnoremap <D-6> 6gt
  imap <D-6> <C-o><D-6>
  nnoremap <D-7> 7gt
  imap <D-7> <C-o><D-7>
  nnoremap <D-8> 8gt
  imap <D-8> <C-o><D-8>
  nnoremap <D-9> 9gt
  imap <D-9> <C-o><D-9>
  nnoremap <D-0> 10gt
  imap <D-0> <C-o><D-0>
else
  set guifont=Monaco\ 16
endif

if has("gui_macvim")
  no <expr> <D-Left> (tabpagenr() ? 'gT' : ':bp')
  no <expr> <D-Right> (tabpagenr() ? 'gt' : ':bn')
  no <D-S-Left> :tabm -1<cr>
  no <D-S-Right> :tabm +1<cr>
  imap <D-S-Left> <C-o><D-S-Left>
  imap <D-S-Right> <C-o><D-S-Right>
  macmenu File.Print key=<nop>
  nnoremap <D-p> :Files<cr>
  inoremap <silent><expr> <D-space> coc#refresh()
endif

" autodark {{{
"func! s:ChangeBackground()
  "if (v:os_appearance)
    "set background=dark
  "else
    "set background=light
  "endif
  "redraw!
"endfunc

"augroup AutoDark
  "autocmd OSAppearanceChanged * call s:ChangeBackground()
"augroup END
" }}}
