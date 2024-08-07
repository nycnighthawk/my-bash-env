augroup myag_python
    autocmd!
    autocmd FileType python setl ff=unix encoding=utf8
augroup END
augroup myag_json
    autocmd!
    autocmd FileType json setl ff=unix encoding=utf8
    autocmd FileType json setl sts=4 shiftwidth=4 tabstop=4 expandtab
augroup END

if did_filetype()
  finish
endif
if getline(1) =~ '^#!'
  setfiletype split(getline(1), '/')[-1]
endif
