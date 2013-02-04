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
set shell=/bin/sh
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
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
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
					\'java', 'vim', 'php'
					\]
		for key in code_fts
			let g:code_ft[key] = 1
		endfor
	endfunction
	call SetCodingFileType()
endif

function! Autosave()
	if &modified && has_key(g:code_ft, &ft)
		write
	endif
endfunction

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  augroup vimrcEx
  au!

  autocmd FileType text setlocal textwidth=78

  au FileChangedShell * Warn "File has been changed outside of Vim."
	au InsertLeave * :call Autosave()

  autocmd FileType ruby,haml,eruby,yaml,jade,javascript,sass,cucumber,coffee
    \ set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

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
"set magic "Set magic on, for regular expressions

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

set t_Co=256
let g:solarized_termcolors=256

if has("gui_running")
  call togglebg#map("<F5>")
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

" dos2unix
function! Txt_dos2unix()
  bufdo! set ff=unix|w
endfunction
" dos2unix end

" Specify the behavior when switching between buffers
set switchbuf=useopen

"map <Left> <Nop>
"map <Right> <Nop>
"map <Up> <Nop>
"map <Down> <Nop>

if has("gui_running")
  nnoremap <C-S-tab> :tabprevious<CR>
  nnoremap <C-tab>   :tabnext<CR>
  inoremap <C-S-tab> <Esc>:tabprevious<CR>i
  inoremap <C-tab>   <Esc>:tabnext<CR>i

  nnoremap <C-h> :tabprevious<CR>
  nnoremap <C-l>   :tabnext<CR>
  inoremap <C-h> <Esc>:tabprevious<CR>i
  inoremap <C-l>   <Esc>:tabnext<CR>i

  if has("mac") || has("macunix")
    nnoremap <D-1> 1gt
    nnoremap <D-2> 2gt
    nnoremap <D-3> 3gt
    nnoremap <D-4> 4gt
    nnoremap <D-5> 5gt
    nnoremap <D-6> 6gt
    nnoremap <D-7> 7gt
    nnoremap <D-8> 8gt
    nnoremap <D-9> 9gt
    nnoremap <D-0> 10gt
  endif
endif

let g:ctrlp_cmd = 'CtrlPMixed'
