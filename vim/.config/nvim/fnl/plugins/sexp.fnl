(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help vim-sexp.txt.
 :guns/vim-sexp
 :tpope/vim-sexp-mappings-for-regular-people)

(gset!
 sexp_mappings {:sexp_round_head_wrap_list    "<i"
                :sexp_round_tail_wrap_list    ">i"
                :sexp_insert_at_list_head     "<I"
                :sexp_insert_at_list_tail     ">I"

                :sexp_round_head_wrap_element "<E"
                :sexp_round_tail_wrap_element ">E"

                :sexp_raise_list              "<r"
                :sexp_raise_element           "<R"
                :sexp_convolute               "\\?"}
 sexp_filetypes "clojure,scheme,lisp,racket,carp,fennel,janet,hy"
 sexp_enable_insert_mode_mappings false)