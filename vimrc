" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

set nocompatible

call pathogen#infect()

set showmode    "show current mode down the bottom
set number      "show line numbers

set hlsearch    "hilight searches by default
set ignorecase
set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points
set autochdir

if &tw < 1
	set tw=78
endif
set colorcolumn=+1 "mark the ideal max text width

"default indent settings
set shiftwidth=2
set softtabstop=2
set tabstop=2
"set expandtab

"folding settings
set foldmethod=indent   "fold based on indent
set nofoldenable        "dont fold by default

set wildmode=list:longest,full   "make cmdline tab completion similar to bash
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

set mouse=a
set ttymouse=xterm2
set hidden

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 25

nnoremap <f2> :NERDTreeToggle<cr>
nnoremap <f3> :TagbarToggle<cr>
nnoremap <F4> :GundoToggle<cr>
set pastetoggle=<F7>

"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
endif

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

"http://vimcasts.org/episodes/fugitive-vim-browsing-the-git-object-database/
"hacks from above (the url, not jesus) to delete fugitive buffers when we
"leave them - otherwise the buffer list gets poluted
"
"add a mapping on .. to view parent tree
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost fugitive://*
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

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

  autocmd FileType ruby,haml,jade,javascript,sass,cucumber,coffee
    \ set sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4

  augroup END

endif " has("autocmd")

nnoremap <leader><leader> <c-^>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   set cscopequickfix=s-,c-,d-,i-,t-,e-
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

set completeopt=longest,menu

set lazyredraw "Don't redraw while executing macros

set si "Smart indet

set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,latin1


set cursorline
set cmdheight=2

" ctags
let b:TypesFileRecurse = 1
let b:TypesFileDoNotGenerateTags = 1
let b:TypesFileIncludeLocals = 1
"let b:TypesFileIncludeSynMatches =1
"let b:TypesFileLanguages = ['c']

let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

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
set bg=dark
colorscheme solarized

" Tagbar plugin settings
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_width = 25
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1

let g:Tb_MaxSize = 2
let g:Tb_TabWrap = 1
if &diff
  let Tb_loaded= 1
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
let g:ctrlp_cmd = 'CtrlPMRU'
set rtp+=/usr/local/opt/go/misc/vim
set sessionoptions-=help
set sessionoptions-=options
let g:session_autoload = 'yes'

nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a; :Tabularize /:\zs<cr>
vmap <leader>a; :Tabularize /:\zs<cr>
