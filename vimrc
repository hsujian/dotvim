" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
if v:progname =~? "evim"
  finish
endif

set nocompatible
" Plugins " {{{
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
let g:AutoPairsShortcutFastWrap = '<C-S-e>'
Plug 'jiangmiao/auto-pairs'

Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'raghur/fruzzy', {'do': { -> fruzzy#install() }}
let g:gundo_prefer_python3 = 1
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1

let NERDTreeChDirMode=2
let g:nerdtree_tabs_open_on_console_startup=1
let NERDTreeIgnore=['\.pyc','\~$','\.swp']
let NERDTreeShowBookmarks=1
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeToggle' }

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdcommenter'

Plug 'altercation/vim-colors-solarized'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
Plug 'editorconfig/editorconfig-vim'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_loc_list_height = 3
Plug 'scrooloose/syntastic'
Plug 'Lokaltog/vim-easymotion'
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-rooter'

Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
Plug 'SirVer/ultisnips'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'

Plug 'tpope/vim-markdown'
Plug 'othree/yajs.vim'
Plug 'wavded/vim-stylus'
Plug 'posva/vim-vue'
Plug 'keith/swift.vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'jparise/vim-graphql'

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
Plug 'fatih/vim-go'

let g:fzf_buffers_jump = 1
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()

let g:fruzzy#usenative = 1
if exists('g:loaded_denite')
  call denite#custom#source('_', 'matchers', ['matcher/fruzzy', 'matcher/project_files'])
end

filetype plugin indent on
syntax on
" " }}}

set showmode
set nu
set hlsearch
set ignorecase
set wrap
set linebreak

set foldmethod=indent
set nofoldenable
set formatoptions-=o
set mouse=a
if !has('nvim')
set ttymouse=xterm2
end
set hidden
set pastetoggle=<F7>
set completeopt=longest,menu
set completeopt-=preview
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
map <silent> <C-F11> :set invlist<CR>
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

if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
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

  autocmd FileType markdown setl sw=4 sts=4 ts=4 noet
  autocmd FileType make,Makefile setl sw=4 sts=4 ts=4 noet
  autocmd FileType c,cpp setl sw=4 sts=4 ts=4 noet
  autocmd FileType yml,yaml setl sw=2 sts=2 ts=2 et indentkeys-=<:>
  autocmd FileType dart setl sw=2 sts=2 ts=2 et
  autocmd filetype svn,*commit* setl spell
  autocmd BufReadPost * call SetCursorPosition()
  autocmd BufReadPost post-receive setl ft=sh

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
    if exists('g:loaded_denite')
      denite -start-insert buffer bookmark
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
"noremap <silent><F1> :call My_buf_switch()<CR>
noremap <silent><F1> :bp<CR>
imap <F1> <C-o><F1>
" switch end

"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)
nnoremap <leader><tab> :NERDTreeToggle <c-r>=GetProjectDir()<cr><cr>

function! UniteGetSource()
  return exists('b:git_dir') ? "file_rec/git" : "file_rec/async:!"
endfunction

call denite#custom#var('file/rec', 'command',
      \ ['rg', '--files', '--glob', '!.git'])
call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
nnoremap <silent> <C-p> :<C-u>Denite
      \ `finddir('.git', ';') != '' ? 'file/rec/git' : 'file/rec'`<CR>

nnoremap <leader>fg :<C-u>DeniteCursorWord -buffer-name=grep -auto-highlight grep:<c-r>=GetProjectDir()<cr><CR>
vnoremap <leader>fg "zy:<C-u>Denite -no-start-insert -auto-highlight grep:<c-r>=GetProjectDir()<cr>::<C-R>z<CR>

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

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
highlight clear SignColumn

function! MyWS()
  if !hlexists('ExtraWhitespace')
    hi ExtraWhitespace ctermbg=red guibg=red
  endif
  match ExtraWhitespace /\s\+$/
endfun
au Syntax * if empty(&buftype) && &modifiable | call MyWS() | endif

set tw=78
set colorcolumn=+1

if executable('rg')
  set grepprg=rg\ -S\ --vimgrep
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['-i', '--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
  call DelTagOfFile(f)
  let resp = system(cmd)
endfunction
"autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()

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

" ----------------------------------------------------------------------------
" fzf
" ----------------------------------------------------------------------------
let g:fzf_launcher = "vim_iterm_function %s"
nnoremap <silent> <Leader>ff :FZF -m<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
