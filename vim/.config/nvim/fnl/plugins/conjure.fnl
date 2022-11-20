(import-macros {: use! : gset!} :macros)

(use!
 ;; See :help conjure.
 :Olical/conjure)

(gset!
 ;; See :help conjure-client-<C-z>.
 conjure#filetype#fennel "conjure.client.fennel.stdio"
 conjure#client#fennel#stdio#command "fennel.bat"
 conjure#log#wrap true
 conjure#log#break_length 80
 conjure#mapping#doc_word "<C-k>")
