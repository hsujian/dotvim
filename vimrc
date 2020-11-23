" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
set nocompatible
let g:codelan = ['go', 'rs', 'rust', 'cc','c','cpp','h', 'html', 'javascript', 'js', 'md', 'php', 'markdown']
" Plugins " {{{
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'jiangmiao/auto-pairs', {'for': g:codelan }
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
let g:rooter_patterns = ['.git', '.git/', 'Cargo.toml', 'go.mod', '_darcs/', '.hg/', '.bzr/', '.svn/']
Plug 'airblade/vim-rooter'

Plug 'ludovicchabant/vim-gutentags', {'for': g:codelan }
Plug 'skywind3000/gutentags_plus', {'for': g:codelan }

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'honza/vim-snippets'

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
Plug 'airblade/vim-gitgutter'

let vim_markdown_preview_browser='Google Chrome'
Plug 'JamshedVesuna/vim-markdown-preview', {'for': ['markdown', 'md']}

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

let g:rustfmt_autosave = 1
Plug 'rust-lang/rust.vim'

Plug 'rhysd/vim-clang-format'

Plug '~/.vim/leetcode'

call plug#end()

" " }}}

set omnifunc=syntaxcomplete#Complete

set sw=2 sts=2 ts=2
set expandtab
set tw=80
set wrap
set cindent
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4

set winwidth=90
set colorcolumn=+1
set nu
set hlsearch
set smartcase
set ignorecase
set linebreak
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

augroup vimrcEx
  au!

  au InsertLeave,FocusGained * set imd imi=0
  au InsertEnter * set imd imi=0

  au FocusLost * silent! wa

  autocmd FileType html,css,javascript setl sw=2 sts=2 ts=2 noet iskeyword+=-
  autocmd FileType yml,yaml setl sw=2 sts=2 ts=2 et indentkeys-=<:>
  autocmd BufReadPost * call SetCursorPosition()
  autocmd FileType c,cpp,java ClangFormatAutoEnable

  au BufWritePost .vimrc,_vimrc,vimrc so $MYVIMRC
augroup END

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
set nobackup
set undofile
nnoremap <leader>u :GundoToggle<cr>

colorscheme solarized

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

if has('macunix')
  function! OpenURLUnderCursor()
    let s:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;()]*')
    let s:uri = shellescape(s:uri, 1)
    if s:uri != ''
      silent exec "!open '".s:uri."'"
      :redraw!
    endif
  endfunction
  nnoremap gx :call OpenURLUnderCursor()<CR>
endif

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
nnoremap <silent> <Leader>ff :RG <C-R><C-W><CR>
nnoremap <leader>b :Buffers<CR>

nnoremap <C-]> g<C-]>

" coc {{{
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

imap <C-j> <Plug>(coc-snippets-expand-jump)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
hi HighlightedyankRegion term=bold ctermbg=0 guibg=#13354A

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" }}}

if has('mac') || has('macunix')
    " Open Dictionary.app on mac systems
    function! OpenDictionary(...)
        let word = ''

        if a:0 > 0 && a:1 !=# ''
            let word = a:1
        else
            let word = shellescape(expand('<cword>'))
        endif
        if &filetype == 'quiz'
            let word = substitute(word, '`', '', 'g')
        endif

        call system("open dict://" . word . ";say ". word)
    endfunction
    command! -nargs=? Dict call OpenDictionary(<q-args>)
endif

" Use H to show documentation in preview window
nnoremap <silent> H :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'h '.expand('<cword>')
  elseif index(g:codelan, &filetype) >= 0 && exists('*CocAction')
    call CocAction('doHover')
  else
    call OpenDictionary()
  endif
endfunction

function! QuizInit()
  hi CTestTerm term=reverse ctermfg=15 ctermbg=2 guibg=DarkGreen guifg=bg
  hi CTestTermQuiz term=reverse ctermbg=brown guibg=brown ctermfg=white guifg=bg
  syn match CTestTerm '\w*`\w*' contains=CTestTermQuiz
  syn match CTestTermQuiz '`\w*'hs=s+1
  let b:coc_suggest_disable = 1
  set iskeyword+=`
  autocmd! CursorHold
endfun
autocmd BufRead,BufNewFile *.ctest setf quiz
autocmd BufRead,BufNewFile *.quiz setf quiz
autocmd FileType quiz call QuizInit()

nnoremap <leader>l :call leetcode#menu()<CR>
