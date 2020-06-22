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
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

Plug 'scrooloose/nerdcommenter'

let g:solarized_hitrail=1
Plug 'altercation/vim-colors-solarized'
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
Plug 'editorconfig/editorconfig-vim'

let g:gundo_prefer_python3 = 1
Plug 'sjl/gundo.vim'
Plug 'airblade/vim-rooter'

Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }

Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'skywind3000/vim-preview'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'honza/vim-snippets'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plug 'airblade/vim-gitgutter'

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

let g:dart_style_guide=1
Plug 'dart-lang/dart-vim-plugin'
call plug#end()

filetype plugin indent on
syntax on
" " }}}

set omnifunc=syntaxcomplete#Complete
set sw=4 sts=4 ts=4
set winwidth=90
set tw=78
set colorcolumn=+1
set nu
set hlsearch
set smartcase
set ignorecase
set showmode
set iminsert=0
set imsearch=-1
set imd

set mouse=a
set hidden
set pastetoggle=<F7>
set lazyredraw
set si
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,latin1
syntax sync minlines=256
set cmdheight=2
set mat=2
"set splitright
"set splitbelow
set updatetime=300
set signcolumn=yes

set autowriteall
set path+=**
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*.so
set wildignore+=*DS_Store*
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*~,*.swp

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
  if &filetype !~# 'commit'
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

  au InsertLeave,FocusGained * set imd imi=0
  au InsertEnter * set imd imi=0

  au FileChangedShell * Warn "File has been changed outside of Vim."
  au FocusLost * silent! wa

  "autocmd FileType markdown setl sw=4 sts=4 ts=4 noet
  "autocmd FileType make,Makefile setl sw=4 sts=4 ts=4 noet
  "autocmd FileType c,cpp setl sw=4 sts=4 ts=4 noet

  autocmd FileType txt let b:coc_suggest_disable = 1
  autocmd FileType html,css,javascript setl sw=2 sts=2 ts=2 noet iskeyword+=-
  autocmd FileType yml,yaml setl sw=2 sts=2 ts=2 et indentkeys-=<:>
  autocmd BufReadPost * call SetCursorPosition()

  au BufWritePost .vimrc,_vimrc,vimrc so $MYVIMRC
  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd User fugitive
  \ if get(b:, 'fugitive_type', '') =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

set undodir^=~/.vim/undo
set backup
set undofile
nnoremap <leader>u :GundoToggle<cr>

silent! colorscheme solarized
"highlight clear SignColumn

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

" don't give |ins-completion-menu| messages.
set shortmess+=c
set signcolumn=yes

set statusline=%n\ %<%.99f\ %{(&paste==1)?'[PASTE]':''}%h%w%m%r\ %1*\ %=
set statusline+=\ %y
set statusline+=%{(&ff!='unix')?&ff:''.(&fenc!='utf-8'&&&fenc!='')?'\ '.&fenc:''.&bomb?'-bom':''}
set statusline+=\ %*%-16(%l,%c-%v\ %P%)

let g:netrw_banner=0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_list_hide = &wildignore
nnoremap <leader><Tab> :Lexplore<CR>

let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['tags']
let g:gutentags_add_default_project_roots = 0
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_plus_switch = 1

nnoremap <leader><Esc> :e $MYVIMRC<CR>

augroup autoquickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
augroup END

let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_COMMAND= 'fd --exclude="*.png" --exclude="*.jpg" --exclude="*.gif" --type f'

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

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
nnoremap <leader>g :call fzf#vim#files('.', {'options':'--no-preview -1 --query '.expand('<cword>')})<CR>
"xnoremap <leader>g :<C-U>call fzf#vim#files('.', {'options':'--no-preview -1 --query '.GetVisual()})<CR>
nnoremap <silent> <Leader>ff :RG <C-R><C-W><CR>
"xnoremap <leader>ff :<C-U>RG <C-R>=GetRawVisual()<CR><CR>
nnoremap <leader>b :Buffers<CR>

nnoremap <C-]> g<C-]>

autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

" coc {{{
nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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

" Setup formatexpr specified filetype(s).
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" Update signature help on jump placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

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

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

hi HighlightedyankRegion term=bold ctermbg=0 guibg=#13354A
" }}}
