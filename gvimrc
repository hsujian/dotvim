" This is Dejian's .gvimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:

set guioptions-=r
set mouse=a
set ttymouse=xterm2

augroup gvimrcEx
  au!

  if !empty($MYGVIMRC)
    au BufWritePost .gvimrc,_gvimrc,gvimrc so $MYGVIMRC
  endif
augroup END

" tab or buf switch
function! My_tb_switch()
  if tabpagenr('$') > 1
    exe "tabn" g:previous_tab
  else
    exe 'b#'
  endif
endfunction
" switch end

au FocusGained * set guitablabel=%M%N\ %t

if has("gui_macvim")
  set guifont=Monaco:h16
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

let g:previous_tab = 1
autocmd TabLeave * let g:previous_tab = tabpagenr()
noremap <F1> :call My_tb_switch()<CR>
imap <F1> <C-o><F1>
