" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
if v:progname =~? "evim"
  finish
endif

set nocompatible
" Plugins " {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'

Plugin 'tpope/vim-sensible'
let g:AutoPairsShortcutFastWrap = '<C-S-e>'
Plugin 'jiangmiao/auto-pairs'

Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/unite-session'

let g:user_emmet_install_global = 0
Plugin 'mattn/emmet-vim'

let NERDTreeChDirMode=2
Plugin 'scrooloose/nerdtree'

Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'

Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular'

Plugin 'altercation/vim-colors-solarized'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'scrooloose/syntastic'
Plugin 'a.vim'

Plugin 'Lokaltog/vim-easymotion'
Plugin 'sjl/gundo.vim'

if has('lua')
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
Plugin 'Shougo/neocomplete.vim'
endif

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
Plugin 'SirVer/ultisnips'
"Plugin 'terryma/vim-multiple-cursors'
Plugin 'joedicastro/vim-multiple-cursors'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plugin 'airblade/vim-gitgutter'
Plugin 'wavded/vim-stylus'
Plugin 'bling/vim-airline'

Plugin 'tpope/vim-markdown'
Plugin 'dart-lang/dart-vim-plugin'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'kchmck/vim-coffee-script'
let coffee_watch_vert = 1
Plugin 'vim-ruby/vim-ruby'
Plugin 'digitaltoad/vim-jade'
Plugin 'rodjek/vim-puppet'
Plugin 'taq/vim-refact'
Plugin 'fatih/vim-go'

call vundle#end()
filetype plugin indent on
syntax on
" " }}}

set showmode
set nu
set hlsearch
set ignorecase
set wrap
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
syntax sync minlines=256
set cmdheight=2
set sessionoptions-=help
set sessionoptions-=options
"set list
map <silent> <F11> :set invlist<CR>
set mat=2
set splitright
set splitbelow
try
  set switchbuf=useopen,usetab,newtab
catch
endtry
nnoremap <F3> :cn<cr>
nnoremap <S-F3> :cp<cr>

augroup MyAutoCmd
  autocmd!
augroup END

set autowriteall
set autochdir
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

function! GetProjectDir(...)
  let dn = expand('%:p:h') . '/'
  let idx = matchend(dn, "/node_modules/[^/]*/")
  if idx > 0
    return dn[:idx-1]
  endif

  if exists('b:git_dir')
    let temp = fnamemodify(b:git_dir, ":s?/\.git.*??")
    if isdirectory(temp)
      return temp
    endif
  endif

  if empty(a:000)
    return getcwd()
  endif
  return a:1
endf

function! LoadCscope(git_dir)
  if filereadable(a:git_dir . '/cscope.out')
    execute 'cs add ' . a:git_dir . '/cscope.out ' . a:git_dir . '/../'
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
function! SetCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction


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

  autocmd FileType html,css EmmetInstall
  autocmd FileType markdown set sw=4 sts=4 ts=4
  autocmd FileType c,cpp,Makefile set sw=4 sts=4 ts=4 noet
  autocmd filetype svn,*commit* setlocal spell
  autocmd BufReadPost * call SetCursorPosition()

  nnoremap <leader><F1> :tabe $MYVIMRC<cr>
  au BufWritePost .vimrc,_vimrc,vimrc so $MYVIMRC
  augroup END

endif " has("autocmd")

nnoremap <leader><leader> <c-^>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
  \ | wincmd p | diffthis

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>

" tab or buf switch
let g:previous_tab = 1
function! My_buf_switch()
  if bufnr('$') == 2
    b#
  elseif bufnr('$') > 2
    if exists('g:loaded_unite')
      Unite -start-insert buffer bookmark
    else
      buffers
      let select_buf_nr = input("Enter buffer number: ")
      if(strlen(select_buf_nr) != 0)
        exe ":buffer ". select_buf_nr
      endif
    endif
  endif
endfunction

function! My_tb_switch()
  if tabpagenr('$') > 1
    exe "tabn" g:previous_tab
  else
    call My_buf_switch()
  endif
endfunction
autocmd TabLeave * let g:previous_tab = tabpagenr()
noremap <silent><F2> :call My_tb_switch()<CR>
imap <F2> <C-o><F2>
noremap <silent><F1> :call My_buf_switch()<CR>
imap <F1> <C-o><F1>
" switch end

nnoremap <leader><tab> :NERDTreeToggle <c-r>=GetProjectDir()<cr><cr>

"let g:unite_enable_start_insert = 1
"let g:unite_force_overwrite_statusline = 0
let g:unite_source_session_options=&sessionoptions
silent! call unite#filters#matcher_default#use(['matcher_fuzzy'])
silent! call unite#filters#sorter_default#use(['sorter_rank'])
silent! call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ '\.hg/',
      \ '\.svn/',
      \ '\.gz',
      \ '\.jpg',
      \ '\.so',
      \ '\.swp',
      \ '\.png',
      \ '\.gif',
      \ 'tmp/',
      \ 'temp/',
      \ '.tmp/',
      \ 'cache',
      \ '.sass-cache',
      \ ], '\|'))
nnoremap <C-p> :<C-u>Unite -buffer-name=files -start-insert buffer file_mru bookmark file_rec/async:<c-r>=GetProjectDir()<cr><cr>
let g:unite_source_grep_default_opts = '-iRHn --binary-files=without-match'
nnoremap <leader>fg :<C-u>UniteWithCursorWord -buffer-name=grep -auto-highlight grep:<c-r>=GetProjectDir()<cr><CR>
vnoremap <leader>fg "zy:<C-u>Unite -no-start-insert -auto-highlight grep:<c-r>=GetProjectDir()<cr>::<C-R>z<CR>
nnoremap <leader><leader>fg :<C-u>UniteResume grep<CR>
nnoremap <leader>r :<C-u>Unite -buffer-name=files -start-insert file_rec/async:<c-r>=GetProjectDir()<cr><CR>
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite history/yank<cr>
nnoremap <leader>ss :<C-u>UniteSessionSave
nnoremap <leader>sr :<C-u>Unite -buffer-name=sessions session
let g:unite_source_session_enable_auto_save = 1
let g:unite_source_file_mru_limit = 1000
let g:unite_cursor_line_highlight = 'TabLineSel'

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

  nmap <silent><buffer><expr> <C-x> unite#do_action('split')
  nmap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  nmap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  nmap <buffer> <ESC> <Plug>(unite_exit)
endfunction

nmap <leader>gw :Gwrite<cr>
nmap <leader>gc :Gcommit<cr>

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

nmap <leader>a= :Tabularize /=<cr>
vmap <leader>a= :Tabularize /=<cr>
nmap <leader>a; :Tabularize /:\zs<cr>
vmap <leader>a; :Tabularize /:\zs<cr>

set undodir^=~/.vim/undo
set undofile
nnoremap <leader>u :GundoToggle<cr>

augroup MyAutoCmd
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
  " autocmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
augroup END

" Make UltiSnips works nicely with other sugg plugin
function! g:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

silent! colorscheme solarized

function! MyWS()
  if !hlexists('ExtraWhitespace')
    hi ExtraWhitespace ctermbg=red guibg=red
  endif
  match ExtraWhitespace /\s\+$/
endfun
au Syntax * if empty(&buftype) && &modifiable | call MyWS() | endif

set tw=78
set colorcolumn=+1

if executable('ag')
  set grepprg=ag\ -S\ --nogroup\ --nocolor
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts =
        \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
        \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
  let g:unite_source_grep_recursive_opt = ''
endif

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" Vim. Live it. ------------------------------------------------------- {{{
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" }}}

noremap <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0' : '^')
noremap <expr> <End> (col('.') == match(getline('.'), '\s*$') ? '$' : 'g_')
vnoremap <expr> <End> (col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_')
imap <Home> <C-o><Home>
imap <End> <C-o><End>
