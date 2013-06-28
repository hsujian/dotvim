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
set hlsearch
set ignorecase
set wrap
set linebreak
set autochdir

set shiftwidth=2
set softtabstop=2
set tabstop=2
"set expandtab
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

if !exists('g:code_ft')
	let g:code_ft = {}
	function! SetCodingFileType()
		let l:code_fts = [
					\'coffee', 'c', 'cpp', 'javascript',
					\'ruby', 'haml', 'jade',
					\'sass', 'yaml', 'python',
					\'java', 'vim', 'php', 'go', 'html'
					\]
		for key in code_fts
			let g:code_ft[key] = 1
		endfor
	endfunction
	call SetCodingFileType()
endif

function! AutoSaveAll()
  let cur_tab = tabpagenr()
  tabdo call Autosave()
  exe "tabn" cur_tab
endfunction

function! Autosave()
	if &modified && &readonly==0 && has_key(g:code_ft, &ft) && (expand("%:r") > "")
		write
	endif
endfunction

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  augroup vimrcEx
  au!

  set iminsert=0
  set imsearch=0
  set imd
  au InsertLeave,FocusGained * set imd imi=0

  au FileChangedShell * Warn "File has been changed outside of Vim."
	au FocusLost * call AutoSaveAll()

  autocmd FileType ruby,haml,jade,javascript,sass,cucumber,coffee,php
    \ set sw=2 sts=2 et
  autocmd FileType python set et

  augroup END

endif " has("autocmd")

nnoremap <leader><leader> <c-^>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis

autocmd BufWritePre * call RemoveTrailingWhitespace()
function RemoveTrailingWhitespace()
  if &diff
    return
  endif
	if !has_key(g:code_ft, &ft)
		return
	endif
  let _s=@/
  let c = col(".")
  let l = line(".")
  silent! %s/\s\+$//
  silent! %s/\(\s*\n\)\+\%$//
  let @/=_s
  call cursor(l, c)
endfunction

if has("gui_running")
	set guifont=Monaco:h16
endif

" tab or buf switch
function! My_tb_switch()
  if tabpagenr('$') > 1
    exe "tabn" g:previous_tab
  else
    exe 'b#'
  endif
endfunction
" switch end

" Specify the behavior when switching between buffers
set switchbuf=useopen

if has("gui_running")
  au FocusGained * set guitablabel=%M%N\ %t

  nnoremap <C-S-tab> gT
  nnoremap <C-tab>   gt
  if has("gui_macvim")
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
  endif
endif
if has("gui_running")
  let Tb_loaded= 1
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
nmap <leader>gw :Gwrite<cr>
nmap <leader>gc :Gcommit<cr>

Bundle 'tpope/vim-fugitive'
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-ragtag'

Bundle 'pangloss/vim-javascript'
Bundle 'kchmck/vim-coffee-script'
Bundle 'vim-ruby/vim-ruby'
Bundle 'digitaltoad/vim-jade'

Bundle 'walm/jshint.vim'

Bundle 'SirVer/ultisnips'
nnoremap <f2> :NERDTreeToggle<cr>
Bundle 'scrooloose/nerdtree'

" Tagbar plugin settings
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_width = 25
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
" ctags
let b:TypesFileRecurse = 1
let b:TypesFileDoNotGenerateTags = 1
let b:TypesFileIncludeLocals = 1
nnoremap <f3> :TagbarToggle<cr>
Bundle 'majutsushi/tagbar'

Bundle 'scrooloose/nerdcommenter'
Bundle 'godlygeek/tabular'
nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a; :Tabularize /:\zs<cr>
vmap <leader>a; :Tabularize /:\zs<cr>

Bundle 'Lokaltog/vim-powerline'

Bundle 'altercation/vim-colors-solarized'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'scrooloose/syntastic'

let g:ctrlp_cmd = 'CtrlPMRU'
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,*~,*/tmp/*,*.so,*.swp,*.zip,*.jpg,*.png,*.gif,*/images/*
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(gz|so|jpg|png|gif)$'
  \ }
Bundle 'kien/ctrlp.vim'

Bundle 'Lokaltog/vim-easymotion'
Bundle 'ZenCoding.vim'
Bundle 'ShowTrailingWhitespace'
Bundle 'Auto-Pairs'
Bundle 'sjl/gundo.vim'
nnoremap <F4> :GundoToggle<cr>
Bundle 'Valloric/YouCompleteMe'
Bundle 'javacomplete'

let g:Tb_MaxSize = 2
let g:Tb_TabWrap = 1
if &diff
  let Tb_loaded= 1
endif
Bundle 'xudejian/TabBar'
Bundle 'xudejian/arrow.vim'

filetype plugin indent on
" " }}}

colorscheme solarized

if &tw < 1
	set tw=78
endif
set colorcolumn=+1
