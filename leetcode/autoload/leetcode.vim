" vim: set et sw=4 sts=4 ts=8:
let s:save_cpo = &cpoptions
set cpoptions&vim

let g:jobs=[job_start('echo'), job_start('echo'), job_start('echo')]
let b:winid=0

function! leetcode#popup(data, opts)
    let l:opts = {
                \ close: 'click',
                \ minwidth: 50,
                \ minheight: 20,
                \ time:10000 }
    if b:winid > 0
        popup_close(b:winid)
    endif
    let b:winid = popup_create(a:data, extend(copy(l:opts), a:opts))
endfunction

function! NoopCb(self, data)
endfunction

function! JobExitCb(self, data)
    let cur = bufnr('%')
    let l:buf = ch_getbufnr(a:self, 'out')
    let l:idx = index(g:jobs, a:self)
    if l:idx == 2
        exec 'b ' . l:buf
        let l:show = getline(1, '$')
        call leetcode#random_cb(l:show)
    elseif l:idx == 0
        exec 'b ' . l:buf
        let l:show = getline(1, '$')
        call leetcode#list_cb(l:show)
    elseif l:idx == 1
        call setqflist([], 'r')
        exec 'silent! cb! ' . l:buf
        let l:lst = getqflist()
        let err = 0
        for d in l:lst
            if index(d.text, "Wrong Answer") > -1
                let err = 1
            endif
            if err == 1
                let d.type = 'E'
                if exists('b:testfname')
                    let d.filename = b:testfname
                endif
            endif
        endfor
        call setqflist(l:lst, 'r')
        copen
    else
        exec 'silent! cb! ' . l:buf
        copen
    endif
    exec l:buf . 'bd'
endfunction

function! leetcode#job(idx, args)
  if job_status(g:jobs[a:idx]) == "run"
      call job_stop(g:jobs[a:idx])
  endif

  let g:jobs[a:idx] = job_start(a:args, {
              \ 'out_io':'buffer',
              \ 'out_cb': 'NoopCb',
              \ 'exit_cb': 'JobExitCb'})
endfunction

function! leetcode#test()
    call inputsave()
    let name = input('Enter test param: ')
    call inputrestore()
    let l:cmd = "leetcode test " . shellescape(expand('%:p')) . ' "'.shellescape(name).'"' 
    call leetcode#job(1, l:cmd)
endfunction

function! leetcode#submit()
    let l:file = expand('%:p')
    if empty(expand(glob(l:file)))
        return
    endif
    let l:cmd = "leetcode submit " . shellescape(l:file)
    call leetcode#job(1, l:cmd)
endfunction

function! leetcode#show(...)
    if empty(expand(glob("include/")))
        return
    endif
    if a:0 > 0
        let id = a:1
    else
        call inputsave()
        let id = input('Enter question number( empty for random ): ')
        call inputrestore()
    endif
    
    let l:cmd = "leetcode show ".shellescape(id, 1)." -q HL -cx -l cpp"
    call leetcode#job(2, l:cmd)
endfunction

function! leetcode#random()
  call leetcode#show()
endfunction

function! leetcode#random_cb(lines)
  let l:show = a:lines
  let l:idx = index(l:show, "/*")
  if l:idx >= 0
      let l:show = l:show[l:idx:]
  endif
  let l:ml = matchlist(l:show, '@lc app=leetcode id=\(\d*\) lang=\(\w*\)')
  if len(l:ml) != 10
      return
  endif
  let l:id = l:ml[1]
  let l:lang = l:ml[2]
  let l:ml = matchlist(l:show, 'https://leetcode\.com/problems/\([^/]*\)/description/')
  if len(l:ml) != 10
      return
  endif
  let l:url = l:ml[0]
  let l:problem = "p".l:id."_".substitute(l:ml[1], "-", "_", "g")
  let l:filename = "include/" . l:problem. ".h"
  if !empty(expand(glob(l:filename)))
      execute "edit" l:filename
      return
  endif
  let l:nshow = []
  let l:guard = toupper('__'.l:problem.'_h__')
  call add(l:nshow, '#ifndef '.l:guard)
  call add(l:nshow, '#define '.l:guard)
  call add(l:nshow, '')
  call add(l:nshow, '#include "header.h"')
  call add(l:nshow, '')
  call add(l:nshow, 'namespace leetcode {')
  call add(l:nshow, 'namespace '.l:problem.' {')
  call add(l:nshow, '')
  let l:nshow += l:show
  call add(l:nshow, '')
  call add(l:nshow, '}  // namespace '.l:problem)
  call add(l:nshow, '}  // namespace leetcode')
  call add(l:nshow, '#endif  // '.l:guard)
  call writefile(l:nshow, l:filename, "")
  let l:testfname = "tests/" . l:problem. ".cc"
  let l:test = []
  call add(l:test, '#include "'. l:problem. '.h"')
  call add(l:test, '')
  call add(l:test, '#include "gtest/gtest.h"')
  call add(l:test, '')
  call add(l:test, 'namespace {')
  call add(l:test, '')
  call add(l:test, 'using namespace leetcode::'.l:problem.';')
  call add(l:test, '')
  call add(l:test, 'TEST('.l:problem.', Example1) {')
  call add(l:test, '  Solution s = Solution();')
  call add(l:test, '  EXPECT_EQ(,);')
  call add(l:test, '}')
  call add(l:test, '')
  call add(l:test, '}  // namespace')
  call writefile(l:test, l:testfname, "")
  execute "edit" l:filename
  let b:filename = l:filename
  let b:testfname = l:testfname
  execute "botright vnew" l:testfname
endfunction

function! leetcode#open_question_under_cursor()
    let l:ml = matchlist(getline('.'), '\[\s*\(\d*\)\s*\]')
    if len(l:ml) != 10
        return
    endif
    if l:ml[1] != ''
        call leetcode#show(l:ml[1])
    endif
endfunction

augroup Leetcode
  autocmd!
  autocmd BufReadPost LEETCODE call leetcode#bufinit()
  autocmd filetype LEETCODE nnoremap <buffer> <enter> :call leetcode#open_question_under_cursor()<CR>
augroup END

function! leetcode#bufinit()
    setlocal nomodified readonly noswapfile
    setlocal nomodifiable
    if &bufhidden ==# ''
        setlocal bufhidden=delete
    endif
    echom 'leetcode buf init'
endfunction

function! leetcode#list_cb(self, data)
    let l:buf = ch_getbufnr(a:self, 'out')
    exec 'b ' . l:buf
    exec 'file [LEETCODE]' 
    set filetype=LEETCODE
    silent doautocmd BufReadPost LEETCODE
endfunction

function! leetcode#list()
    if bufexists('[LEETCODE]')
        exec 'b ' . bufnr('[LEETCODE]')
        return
    endif
    if job_status(g:jobs[0]) == "run"
        call job_stop(g:jobs[0])
    endif

    let g:jobs[0] = job_start("leetcode list -q L", {
                \ 'out_io':'buffer',
                \ 'out_cb': 'NoopCb',
                \ 'exit_cb': 'leetcode#list_cb'})
endfunction

func! leetcode#menu_click(id, key)
    if a:key == 1
        call leetcode#list()
    elseif a:key == 2
        call leetcode#test()
    elseif a:key == 3
        call leetcode#submit()
    elseif a:key == 4
        call leetcode#random()
    endif
endfunc
function! leetcode#menu()
    call popup_menu(['List', 'Test', 'Submit', 'PickOne'], #{
                \ callback: 'leetcode#menu_click',
                \ })
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
