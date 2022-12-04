(import-macros {: use! : gset! : aucmd! : bind!} :macros)

(use!
 ;; See :help undotree.txt.
 :mbbill/undotree)

(gset!
 undotree_SetFocusWhenToggle true
 undotree_HelpLine           false
 undotree_WindowLayout       2)

(aucmd!
 (:group
  "undotree-bindings"
  Filetype
  :pattern "undotree"
  #(bind! "<ESC>" nbr "<TAB>")))
