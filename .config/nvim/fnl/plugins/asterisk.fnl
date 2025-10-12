(import-macros {: gset! : bind!} :macros)

;; Enhance searching with *, see :help asterisk.txt.
{1 :haya14busa/vim-asterisk
 :event :VeryLazy
 :init (fn []
         (gset!
          ;; Stay in the same column.
          asterisk#keeppos true)

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

