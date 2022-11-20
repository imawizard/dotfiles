(import-macros {: use! : gset! : bind!} :macros)

(use!
 ;; Enhance searching with *, see :help asterisk.txt.
 :haya14busa/vim-asterisk)

(gset!
 ;; Stay in the same column.
 asterisk#keeppos true)

(bind!
 "*"  nvor "<Plug>(asterisk-*)"
 "g*" nvor "<Plug>(asterisk-g*)"
 "g#" nvor "<Plug>(asterisk-g#)"

 ;; 'Stay' variants for searching.
 "z*"  nvor "<Plug>(asterisk-z*)"
 "z#"  nvor "<Plug>(asterisk-z#)"
 "gz*" nvor "<Plug>(asterisk-gz*)"
 "gz#" nvor "<Plug>(asterisk-gz#)")
