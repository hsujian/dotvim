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
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdcommenter'

Plug 'altercation/vim-colors-solarized'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
Plug 'editorconfig/editorconfig-vim'

let g:gundo_prefer_python3 = 1
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-rooter'

Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'honza/vim-snippets'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plug 'airblade/vim-gitgutter'

Plug 'tpope/vim-markdown'
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_browser='Google Chrome'
Plug 'JamshedVesuna/vim-markdown-preview'

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'dart-lang/dart-vim-plugin'
call plug#end()

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
set updatetime=300
set signcolumn=yes
nnoremap <F3> :cn<cr>
nnoremap <S-F3> :cp<cr>

set autowriteall
set path+=**
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*~
set wildignore+=*DS_Store*
set wildignore+=vendor/**
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
  set imsearch=-1
  set imd
  au InsertLeave,FocusGained * set imd imi=0
  au InsertEnter * set imd imi=0

  au FileChangedShell * Warn "File has been changed outside of Vim."
  au FocusLost * silent! wa

  autocmd FileType markdown setl sw=4 sts=4 ts=4 noet nonu
  autocmd FileType markdown let b:coc_suggest_disable = 1
  autocmd FileType go let b:coc_pairs_disabled = ['<']
  autocmd FileType make,Makefile setl sw=4 sts=4 ts=4 noet
  autocmd FileType c,cpp setl sw=4 sts=4 ts=4 noet
  autocmd FileType yml,yaml setl sw=2 sts=2 ts=2 et indentkeys-=<:>
  autocmd filetype svn,*commit* setl spell
  autocmd BufReadPost * call SetCursorPosition()

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

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if get(b:, 'fugitive_type', '') =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

set undodir^=~/.vim/undo
set undofile
nnoremap <leader>u :GundoToggle<cr>

silent! colorscheme solarized
"highlight clear SignColumn
hi HighlightedyankRegion term=bold ctermbg=0 guibg=#13354A

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
  set grepformat^=%f:%l:%c:%m
endif

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

vmap <C-c> "+y
" 映射切换buffer的键位
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>

nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" don't give |ins-completion-menu| messages.
set shortmess+=c
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
    autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " autocmd FileType java setlocal omnifunc=eclim#java#complete#CodeComplete
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

set statusline=[%n]\ %<%.99f\ %h%w%m%r%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%y%=%-16(\ %l,%c-%v\ %)%P

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

"{{snippet}}
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

let g:netrw_banner=0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_list_hide = &wildignore
autocmd FileType netrw set nolist

let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_project_root = ['.idea', '.root', 'go.mod']
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_plus_switch = 1

let g:Lf_RootMarkers = ['.git', '.idea', '.svn', '.hg', '.root', 'go.mod']
let g:Lf_IgnoreCurrentBufferName = 1

noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsSkipUnreadable = 1
let g:Lf_ShowDevIcons = 0
"let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>

nnoremap <leader><Esc> :vs $MYVIMRC<CR>

augroup autoquickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
augroup END

let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_COMMAND= 'fd --exclude="*.png" --exclude="*.jpg" --exclude="*.gif" --type f'

" return the visually selected text and quote it with double quote
function! GetVisual() abort
    try
        let x_save = @x
        norm! gv"xy
        return '"' . escape(@x, '"') . '"'
    finally
        let @x = x_save
    endtry
endfunction
function! GetRawVisual() abort
    try
        let x_save = @x
        norm! gv"xy
        return @x
    finally
        let @x = x_save
    endtry
endfunction

nnoremap <C-p> :call fzf#vim#files('.', {'options':'--no-preview'})<CR>
nnoremap <leader>g :call fzf#vim#files('.', {'options':'--no-preview --query '.expand('<cword>')})<CR>
xnoremap <leader>g :<C-U>call fzf#vim#files('.', {'options':'--no-preview --query '.GetVisual()})<CR>
nnoremap <silent> <Leader>ff :Rg <C-R><C-W><CR>
xnoremap <leader>ff :<C-U>Rg <C-R>=GetRawVisual()<CR><CR>
