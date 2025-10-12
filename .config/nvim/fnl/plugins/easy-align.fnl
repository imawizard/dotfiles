(import-macros {: gset! : bind!} :macros)

;; Align with e.g. :EasyAlign */[:;]\+/, see :help easy-align.txt.
{1 :junegunn/vim-easy-align
 :cmd [:EasyAlign
       :EasyAlignRepeat]
 :keys ["<Plug>(EasyAlign)"
        "<Plug>(EasyAlignRepeat)"]
 :init (fn []
         (gset!
          easy_align_delimiters {;; for semicolon comments
                                 ";" {"pattern" ";"
                                      "stick_to_left" 0
                                      "ignore_groups" []}})
         (bind!
          :desc "EasyAlign" "gl" nx "<Plug>(EasyAlign)"
                            "."   x "<Plug>(EasyAlignRepeat)"))}
