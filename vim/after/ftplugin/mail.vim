"setlocal formatoptions+=aw  " Allow for flow formatted paragraphs in 
                            " mail.  This *should* let me interact
                            " better with other mail user agents.
" Or do it right and use something like what I setup for LaTeX
setlocal formatoptions=l
setlocal textwidth=0
setlocal wrap
setlocal linebreak
setlocal listchars+=eol:$,tab:>→,trail:↧,extends:↩
setlocal list

nnoremap j gj
nnoremap k gk
