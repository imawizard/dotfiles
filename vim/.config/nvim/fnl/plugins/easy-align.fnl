(import-macros {: use! : gset! : bind!} :macros)

(use!
 ;; Align with e.g. :EasyAlign */[:;]\+/, see :help easy-align.txt.
 {:config
  (fn []
    (bind!
     "gl" nx "<Plug>(EasyAlign)"
     "."   x "<Plug>(EasyAlignRepeat)"))}
 :junegunn/vim-easy-align)

(gset!
 easy_align_delimiters {;; for semicolon comments
                        ";" {"pattern" ";"
                             "stick_to_left" 0
                             "ignore_groups" []}})
