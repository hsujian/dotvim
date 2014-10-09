function! AutoCorrect()
	ia destory destroy
endfunction

au Syntax javascript if &modifiable | call AutoCorrect() | endif
au Syntax coffee if &modifiable | call AutoCorrect() | endif
