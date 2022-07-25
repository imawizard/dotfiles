" See https://github.com/equalsraf/neovim-qt/wiki/Configuration-Options

" Disable fzf colors
if has('win32')
    let g:fzf_colors = {}
endif

" Set Editor Font
if exists(':GuiFont') && has('win32')
    GuiFont! FiraCode\ Nerd\ Font\ Mono:h11
endif

" Disable GUI Tabline
if exists(':GuiTabline')
    GuiTabline 0
endif

" Enable GUI Popupmenu
if exists(':GuiPopupmenu')
    GuiPopupmenu 1
endif

" Disable GUI ScrollBar
if exists(':GuiScrollBar')
    GuiScrollBar 0
endif

" Right Click Context Menu (Copy-Cut-Paste)
if exists(':GuiShowContextMenu')
    nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
    inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
    vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
endif

" Enable Drag & Drop
fun! GuiDropCustomHandler(...)
    let fnames = deepcopy(a:000)
    let args = map(fnames, 'fnameescape(v:val)')

    for file in args
        echom "You just opened: " . file
        exec 'drop '. substitute(file, ' ', '\ ', 'g')
    endfor
endfun

" Paste with S-C-v.
if has('win32')
    nnoremap <S-C-v> P
    inoremap <S-C-v> <C-r>*
    cnoremap <S-C-v> <C-r>*
endif
