" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"activate pathogen
call pathogen#infect()

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set number      "show line numbers
set switchbuf=useopen
set winwidth=79

"display tabs and trailing spaces
""set list
set listchars=eol:¬,tab:▷⋅,trail:⋅,nbsp:⋅,precedes:<,extends:>
hi SpecialKey ctermfg=7 ctermbg=1

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default
set ignorecase smartcase

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points
set shell=/bin/sh
set splitright
"set splitbelow

if v:version >= 703
    "undo settings
    set undodir=~/.vim/undofiles
    set undofile

    set colorcolumn=+1 "mark the ideal max text width
endif

"default indent settings
set shiftwidth=2
set softtabstop=2
set tabstop=2
"set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax enable
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

set laststatus=2

"nerdtree settings
let g:NERDTreeMouseMode = 2
let g:NERDTreeWinSize = 25

"explorer mappings
nnoremap <f2> :NERDTreeToggle<cr>
nnoremap <f3> :TagbarToggle<cr>
nnoremap <F4> :GundoToggle<cr>

"source project specific config files
""runtime! projects/**/*.vim

"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
endif

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

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

let g:autosave_on_focus_change=1
function! Autosave()
	if &modified && g:autosave_on_focus_change
		write
		echo "Autosaved file while you were absent" 
	endif
endfunction

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  au FileChangedShell * Warn "File has been changed outside of Vim."
	au InsertLeave * :call Autosave()

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber
    \ set ai sw=2 sts=2 et tw=78
  autocmd FileType python set sw=4 sts=4 et tw=78

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  augroup END

endif " has("autocmd")

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

set nolazyredraw "Don't redraw while executing macros
"set magic "Set magic on, for regular expressions
set showmatch "Show matching bracets when text indicator is over them

set si "Smart indet

set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,latin1

set ruler " show the cursor position all the time

" set cursorcolumn
set cursorline
set cmdheight=2

" ctags
let b:TypesFileRecurse = 1
let b:TypesFileDoNotGenerateTags = 1
let b:TypesFileIncludeLocals = 1
"let b:TypesFileIncludeSynMatches =1
"let b:TypesFileLanguages = ['c']]

let g:SuperTabRetainCompletionType=2
let g:SuperTabDefaultCompletionType="<C-X><C-O>"

let c_space_errors = 1
let java_space_errors = 1
autocmd BufWritePre vimrc,*.{cpp,h,c,php,xml,java,coffee}
  \ call RemoveTrailingWhitespace()
function RemoveTrailingWhitespace()
  if &ft != "diff"
    let b:curcol = col(".")
    let b:curline = line(".")
    silent! %s/\s\+$//
    silent! %s/\(\s*\n\)\+\%$//
    call cursor(b:curline, b:curcol)
  endif
endfunction

au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!

if &textwidth < 1
  setlocal textwidth=78
endif

set pastetoggle=<F7>

"tell the term has 256 colors
set t_Co=256

if has("gui_running")
  let g:solarized_termcolors=256
  ""call togglebg#map("<F5>")
	set guifont=Monaco:h14
	set background=light
	colorscheme solarized
else
	set background=dark
  colorscheme grb256
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ARROW KEYS ARE UNACCEPTABLE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""map <Left> <Nop>
""map <Right> <Nop>
""map <Up> <Nop>
""map <Down> <Nop>

""" Tagbar plugin settings
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_width = 25
let g:tagbar_iconchars = ['+', '-']

" Auto-open tagbar only if not in diff mode and the term wide enough to also
" fit an 80-column window (plus eight for line numbers and the fold column).
if &columns > 250
    if ! &diff
        au VimEnter * nested :call tagbar#autoopen(1)
    endif
else
    let g:tagbar_autoclose = 1
    let g:tagbar_autofocus = 1
endif

hi CursorLine cterm=bold
hi LineNr cterm=bold ctermfg=0 ctermbg=none

"minibufexpl
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplSortBy = "mru"
hi MBEVisibleActive guifg=#A6DB29 guibg=fg
hi MBEVisibleChangedActive guifg=#F1266F guibg=fg
hi MBEVisibleChanged guifg=#F1266F guibg=fg
hi MBEVisibleNormal guifg=#5DC2D6 guibg=fg
hi MBEChanged guifg=#CD5907 guibg=fg
hi MBENormal guifg=#808080 guibg=fg
"minibufexpl end

let g:ConqueTerm_StartMessages=0
let g:ConqueTerm_CloseOnEnd = 1
let g:ConqueTerm_ReadUnfocused = 1
