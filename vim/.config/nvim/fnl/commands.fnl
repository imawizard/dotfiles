(vim.cmd
 "
 \" Change indentation.
 command! -range=% -nargs=0 Tb2Sp exe '<line1>,<line2>s#^\\t\\+#\\=repeat(\" \", len(submatch(0))*' . &ts . ')'
 command! -range=% -nargs=0 Sp2Tb exe '<line1>,<line2>s#^\\( \\{' . &ts . '\\}\\)\\+#\\=repeat(\"\\t\", len(submatch(0))/' . &ts . ')'

 \" Diff current buffer and file it was loaded from.
 command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

 \" Trim trailing whitespaces.
 command! StripTrailingWS call StripTrailingWhitespaces()

 \" Append modeline after last line in buffer.
 command! AppendModeline call AppendModeline()

 \" Open or focus nuake.
 command! FocusNuake call FocusNuake()

 \" Save file with sudo.
 command! W w !sudo tee % >/dev/null

 \" Reload and open vim config.
 command! Reload exe 'source ' . $MYVIMRC
 command! Editrc exe 'tabedit ' . $MYVIMRC

 fun! AppendModeline() abort
     \" Other examples:  vim:tw=78:ts=8:ft=help:norl:noet:fen:fdl=0:fdm=marker:
     \"                  vim:tw=78:ts=2:sts=2:sw=2:ft=help:norl:
     \"                  vim:tw=78:sw=4:noet:ts=8:ft=help:norl:
     let opts = printf(\" vim: set tw=%d%s ts=%d sw=%d %set: \",
         \\ &textwidth,
         \\ &wrap ? ' wrap' : '',
         \\ &tabstop,
         \\ &shiftwidth,
         \\ &expandtab ? '' : 'no'
         \\ )
     let modeline = substitute(&commentstring, '%s', opts, 'g')
     call append(line(\"$\"), modeline)
 endfun

 fun! StripTrailingWhitespaces() abort
     let l = line('.')
     let c = col('.')
     %s/\\s\\+$//e

     let end = line('$')
     let start = end
     while start > 0
       let line = getline(start)
       if line !=? ''
         break
       endif
       let start = start - 1
     endwhile
     if end - start > 0
       exe ':' . (start+1) . ',' . end . 'd'
     endif

     call cursor(l, c)
 endfun

 fun! FocusNuake() abort
     let winnr = -1
     if exists('t:nuake_buf_nr')
         let winnr = bufwinnr(t:nuake_buf_nr)
     endif
     if winnr == -1 || winnr == winnr()
         exe 'Nuake'
     else
         exe winnr . \"wincmd w\"
     endif
 endfun

 \" Cycle between myers, patience and histogram for diffing.
 fun! CycleDiffAlgo()
     let algos = ['algorithm:myers', 'algorithm:patience', 'algorithm:histogram']
     let current = &diffopt
     for i in range(0, len(algos)-1)
         let algo = algos[i]
         if current =~ algo
             let newalgo = algos[(i+1) % len(algos)]
             exe 'setlocal diffopt-=' .. algo
             exe 'setlocal diffopt+=' .. newalgo
             echo 'Diff algo set to ' . newalgo
             return
         endif
     endfor
 endfun

 \" Cycle the current folding method.
 fun! CycleFolding()
     let methods = {
         \\   'marker': [
         \\     'setlocal foldmethod=marker',
         \\     'setlocal foldmarker={{{,}}}',
         \\   ],
         \\   'treesitter': [
         \\     'setlocal foldmethod=expr',
         \\     'setlocal foldexpr=nvim_treesitter#foldexpr()',
         \\   ],
         \\   'syntax': [
         \\     'setlocal foldmethod=syntax',
         \\   ],
         \\   'indent': [
         \\     'setlocal foldmethod=indent',
         \\   ],
         \\   'diff': [
         \\     'setlocal foldmethod=diff',
         \\   ],
         \\ }
     let keys = keys(methods)
     let idx = exists('b:foldmethod')
         \\ ? index(keys, b:foldmethod)
         \\ : 0
     let next = keys[(idx+1) % len(keys)]
     for l in methods[next]
         exe l
     endfor
     let b:foldmethod = next
     echo 'Fold method set to ' . next
 endfun
 ")
