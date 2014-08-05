function! MyWS()
  if !hlexists('ExtraWhitespace')
    hi ExtraWhitespace ctermbg=red guibg=red
  endif
  match ExtraWhitespace /\s\+$/
endfun
au Syntax * if empty(&buftype) && &modifiable | call MyWS() | endif

function! MySpellBad(cluster)
  syn keyword mySpellBad destory
  hi def link mySpellBad ExtraWhitespace
  exec 'syn cluster ' a:cluster  ' add=mySpellBad'
endfun

au Syntax javascript if empty(&buftype) && &modifiable | call MySpellBad('javaScriptAll') | endif
au Syntax coffee if empty(&buftype) && &modifiable | call MySpellBad('coffeeAll') | endif
