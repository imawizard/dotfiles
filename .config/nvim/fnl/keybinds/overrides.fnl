(import-macros {: bind!} :macros)

(bind!
 ;; Move through wrapped lines.
 "j" n "gj"
 "k" n "gk"
 "j" x "gj"
 "k" x "gk"

 ;; Paste and keep clipboard.
 "p" x "pgvy"

 ;; Start search with 'magic'.
 "/"   n! "/\\m"
 "?"   n! "?\\m"
 "%s/" c! "%sm//g<Left><Left>"

 ;; Don't exit visual mode on shifting.
 "<" x "<gv"
 ">" x ">gv"

 ;; Respect an already typed prefix when iterating through history.
 "<C-p>" ce! #(if (> (vim.fn.wildmenumode) 0) "<C-p>" "<Up>")
 "<C-n>" ce! #(if (> (vim.fn.wildmenumode) 0) "<C-n>" "<Down>")

 ;; Basic emacs bindings.
 "<C-b>"  ic!  "<Left>"
 "<C-f>"  ic!  "<Right>"
 "<C-d>"  c!   "<Del>"
 "<C-a>"  ie   #(.. "<ESC>" (if (> (vim.fn.col ".") 1) "0" "_") "i")
 "<C-a>"  c!   "<Home>"
 "<C-e>"  ie   #(if (> (vim.fn.pumvisible) 0) "<C-e>" "<End>")
 "<C-e>"  c!   "<End>"
 "<C-BS>" ict! "<C-w>"

 ;; Make original C-e accessible through S-C-y.
 "<S-C-y>" i "<C-e>"

 ;; Remap to backspace for autoclose-bindings.
 "<C-h>" icr! "<BS>")
