(import-macros {: use! : gset! : bind!} :macros)

(use!
 ;; Enhance searching with *, see :help asterisk.txt.
 {:config
  (fn []
    (bind!
     ;; Remap vanilla keys.
     "*"   nvo "<Plug>(asterisk-*)"
     "g*"  nvo "<Plug>(asterisk-g*)"
     "g#"  nvo "<Plug>(asterisk-g#)"

     ;; 'Stay' variants for searching.
     "z*"  nvo "<Plug>(asterisk-z*)"
     "z#"  nvo "<Plug>(asterisk-z#)"
     "gz*" nvo "<Plug>(asterisk-gz*)"
     "gz#" nvo "<Plug>(asterisk-gz#)"))}
 :haya14busa/vim-asterisk)

(gset!
 ;; Stay in the same column.
 asterisk#keeppos true)
