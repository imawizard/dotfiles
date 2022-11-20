(vim.cmd
 "
 augroup packer_user_config
   autocmd!
   autocmd BufWritePost */nvim/fnl/{plugins/*,langs/*,keybinds}.fnl source $MYVIMRC | edit | PackerCompile
 augroup end

 augroup close-preview-after-completion
   autocmd!
   autocmd InsertLeave,CompleteDone * if !pumvisible() | silent! pclose | endif
 augroup end

 augroup autosave-like-intellij
   autocmd!
   autocmd WinLeave,FocusLost * silent! wall
 augroup end

 \"augroup revert-to-normal-mode
 \"  autocmd!
 \"  autocmd FocusLost * call feedkeys(\"\\<C-\\>\\<C-n>\")
 \"augroup end

 augroup highlight-on-yank
   autocmd!
   autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup=\"HighlightedyankRegion\", timeout=400})
 augroup end

 augroup restore-C-m-if-readonly
   autocmd!
   \"autocmd BufReadPost * if !&modifiable | nnoremap <buffer> <CR> <CR> | endif
   \"autocmd Filetype netrw nnoremap <buffer> <CR> <CR>
 augroup end
 ")
