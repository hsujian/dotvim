" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set nocompatible

set showmode
set number
set numberwidth=1
set hlsearch
set ignorecase
set wrap
set guioptions-=r
set linebreak

set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set foldmethod=indent
set nofoldenable
set formatoptions-=o
set mouse=a
set ttymouse=xterm2
set hidden
set pastetoggle=<F7>
set completeopt=longest,menu
set lazyredraw
set si
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,latin1
set cursorline
set cmdheight=2
set rtp+=/usr/local/opt/go/misc/vim
set sessionoptions-=help
set sessionoptions-=options
set list
map <silent> <F11> :set invlist<CR>
set mat=2
set splitright
set splitbelow
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
nnoremap <F3> :cn<cr>
nnoremap <S-F3> :cp<cr>

augroup MyAutoCmd
  autocmd!
augroup END

function! Grep(str)
  let @/ = a:str
  exe "grep -srn --binary-files=without-match --exclude-dir=.git --exclude='*.swp' . -e ".shellescape(a:str)
  cwindow
endfunction

function! GrepWord(str)
  let @/ = a:str
  exe "grep -srnw --binary-files=without-match --exclude-dir=.git --exclude='*.swp' . -e ".shellescape(a:str)
  cwindow
endfunction

nnoremap <leader><F1> :tabe ~/.vim/vimrc<cr>
nnoremap <leader>f :silent noautocmd call Grep(expand('<cword>'))<bar>set hls<cr>
nnoremap <leader>fw :silent noautocmd call GrepWord(expand('<cword>'))<bar>set hls<cr>
vnoremap <leader>f y:silent noautocmd call Grep(@@)<bar>set hls<cr>
set autowriteall
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*~
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

function! LoadCscope(git_dir)
  if filereadable(a:git_dir . '/cscope.out')
    execute 'cs add ' . a:git_dir . '/cscope.out ' . a:git_dir . '/../'
  endif
endf

function! Chdir2Project(git_dir)
  let temp = fnamemodify(a:git_dir, ":s?/\.git.*??")
  if isdirectory(temp)
    exec 'lc ' temp
  endif
endf

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

"spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  augroup vimrcEx
  au!

  set iminsert=0
  set imsearch=0
  set imd
  au InsertLeave,FocusGained * set imd imi=0
  au InsertEnter * set imd imi=0

  au FileChangedShell * Warn "File has been changed outside of Vim."
  au FocusLost * silent! wa

  autocmd FileType markdown set sw=4 sts=4 ts=4

  augroup END

endif " has("autocmd")

nnoremap <leader><leader> <c-^>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis

nmap <leader>tw :call RemoveTrailingWhitespace()<cr>
function! RemoveTrailingWhitespace()
  let _s=@/
  let c = col(".")
  let l = line(".")
  silent! %s/\s\+$//
  silent! %s/\(\s*\n\)\+\%$//
  let @/=_s
  call cursor(l, c)
endfunction

" tab or buf switch
function! My_tb_switch()
  if tabpagenr('$') > 1
    exe "tabn" g:previous_tab
  else
    exe 'b#'
  endif
endfunction
" switch end

if has("gui_running")
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
  endif
endif
if has("gui_running")
  let g:previous_tab = 1
  autocmd TabLeave * let g:previous_tab = tabpagenr()
  noremap <F1> :call My_tb_switch()<CR>
  imap <F1> <C-o><F1>
else
  set wildchar=<Tab> wildmenu wildmode=full
  set wildcharm=<C-Z>
  nnoremap <F1> :b <C-Z>
  imap <F1> <C-o><F1>
endif

nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" Plugins " {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-sensible'

Bundle 'Shougo/vimproc.vim'
Bundle 'mileszs/ack.vim'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/unite-session'

let g:unite_enable_start_insert = 1
let g:unite_force_overwrite_statusline = 0
let g:unite_winheight = 10
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ '\.hg/',
      \ '\.svn/',
      \ '\.gz',
      \ '\.jpg',
      \ '\.so',
      \ '\.png',
      \ '\.gif',
      \ 'tmp/',
      \ '.sass-cache',
      \ ], '\|'))
nnoremap <C-p> :<C-u>Unite -buffer-name=files -start-insert buffer file_mru bookmark file_rec/async<cr>
nnoremap <leader>ls :<C-u>Unite -quick-match buffer<cr>
nnoremap <leader>fg :<C-u>Unite -buffer-name=grep grep:.<CR>
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite history/yank<cr>
nnoremap <leader>ss :<C-u>UniteSessionSave
nnoremap <leader>sr :<C-u>Unite -buffer-name=sessions session
let g:unite_source_session_enable_auto_save = 1
let g:unite_split_rule = "botright"
let g:unite_source_file_mru_limit = 1000
let g:unite_cursor_line_highlight = 'TabLineSel'

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a --binary-files=without-match'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color -a --binary-files=without-match'
  let g:unite_source_grep_recursive_opt = ''
endif

nnoremap <leader><tab> :NERDTreeToggle<cr>
Bundle 'scrooloose/nerdtree'

Bundle 'tpope/vim-fugitive'
nmap <leader>gw :Gwrite<cr>
nmap <leader>gc :Gcommit<cr>

function! Fugitive_settings()
  set bufhidden=delete
  if fugitive#buffer().type() =~# '^\%(tree\|blob\)$'
    nnoremap <buffer> .. :edit %:h<cr>
  endif
endfunction

function! Git_dir_settings()
  if exists('b:git_dir')
    call s:JumpInit()
    call LoadCscope(b:git_dir)
  endif
endfunction

function! Ch2git_root()
  if exists('b:git_dir')
    call Chdir2Project(b:git_dir)
  endif
endfunction

augroup fugitive
  autocmd!
  autocmd BufNewFile,BufReadPost * call Git_dir_settings()
  autocmd BufReadPost fugitive://* call Fugitive_settings()
  autocmd BufEnter * call Ch2git_root()
augroup END

Bundle 'tpope/vim-surround'

Bundle 'scrooloose/nerdcommenter'
Bundle 'godlygeek/tabular'
nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a; :Tabularize /:\zs<cr>
vmap <leader>a; :Tabularize /:\zs<cr>

Bundle 'altercation/vim-colors-solarized'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'scrooloose/syntastic'

Bundle 'Lokaltog/vim-easymotion'
Bundle 'sjl/gundo.vim'
set undodir^=~/.vim/undo
set undofile
nnoremap <leader>u :GundoToggle<cr>

if has('lua')
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
Bundle 'Shougo/neocomplete.vim'
endif

augroup MyAutoCmd
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  " autocmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
augroup END

Bundle 'SirVer/ultisnips'
Bundle 'xudejian/arrow.vim'
Bundle 'terryma/vim-multiple-cursors'
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Bundle 'airblade/vim-gitgutter'

let g:user_emmet_install_global = 0
Bundle 'mattn/emmet-vim'
autocmd FileType html,css EmmetInstall

Bundle 'bling/vim-airline'

Bundle 'tpope/vim-markdown'
Bundle 'dart-lang/dart-vim-plugin'
Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
let coffee_watch_vert = 1
Bundle 'vim-ruby/vim-ruby'
Bundle 'digitaltoad/vim-jade'

let g:AutoPairsShortcutFastWrap = '<C-S-m>'
Bundle 'jiangmiao/auto-pairs'

filetype plugin indent on
" " }}}

function! My_HiTrail()
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
endfunction
autocmd! Syntax * call My_HiTrail()
autocmd! ColorScheme * call My_HiTrail()

augroup MyAutoCmd
  autocmd BufWinEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd InsertEnter * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+\%#\@<!$/ | endif
  autocmd InsertLeave * if &modifiable && &ft!='unite' | match ExtraWhitespace /\s\+$/ | endif
  autocmd BufWinLeave * if &modifiable && &ft!='unite' | call clearmatches() | endif
augroup END

colorscheme solarized

set tw=78
set colorcolumn=+1
xmap <Tab> >
xmap <s-tab> <
