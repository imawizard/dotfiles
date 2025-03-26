(import-macros {: bind!} :macros)

(bind!
 (:when (not= (os.getenv "VIM_CUSTOM_KEYBINDS") nil)
   ;; Use jk to cycle through panes (counter-)clockwise and JK to swap them.
   "<C-w>j" n "<C-w>w"
   "<C-w>k" n "<C-w>W"
   "<C-w>J" n "mX<C-w>wmY'X<C-w>W'Y<C-w>w"
   "<C-w>K" n "mX<C-w>WmY'X<C-w>w'Y<C-w>W"

   ;; Move current line up and down.
   "<C-9>" n ":move .+1<CR>=="
   "<C-0>" n ":move .-2<CR>=="
   "<C-9>" i "<ESC>:move .+1<CR>==gi"
   "<C-0>" i "<ESC>:move .-2<CR>==gi"
   "<C-9>" x ":move '>+1<CR>gv=gv"
   "<C-0>" x ":move '<-2<CR>gv=gv"

   ;; Move through wrapped lines.
   "j" n "gj"
   "k" n "gk"
   "j" x "gj"
   "k" x "gk"

   ;; Paste and keep clipboard.
   "p" x "pgvy"

   ;; Start search with '(very) magic'.
   "/"   n! "/\\v"
   "?"   n! "?\\v"
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
   "<C-h>" icr! "<BS>"))
