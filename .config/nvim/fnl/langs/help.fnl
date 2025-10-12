(import-macros {: aucmd! : bind!} :macros)

(aucmd!
 Filetype
 ; :group "ft-help"
 :pattern "help"
 :once true

 #(do
   (bind!
    "q" nb "<C-w>c")
   (tset vim.b :shit true)))



{}
