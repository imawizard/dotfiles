" See https://github.com/equalsraf/neovim-qt/wiki/Configuration-Options.

" Enable Drag & Drop
fun! GuiDropCustomHandler(...)
    let fnames = deepcopy(a:000)
    let args = map(fnames, 'fnameescape(v:val)')

    for file in args
        echom "Opened file: " . file
        exec 'drop '. substitute(file, ' ', '\ ', 'g')
    endfor
endfun

" Paste with S-C-v.
if has('win32')
    nnoremap <S-C-v> P
    inoremap <S-C-v> <C-r>*
    cnoremap <S-C-v> <C-r>*
    tnoremap <S-C-v> <C-\><C-n>Pi
endif
