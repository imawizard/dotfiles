(import-macros {: use! : aucmd! : bind! : has?} :macros)

(use!
 ;; Similiar to NERDTree, see :help nvim-tree.lua.
 {:requires [:nvim-lua/plenary.nvim
             :nvim-tree/nvim-web-devicons]
  :config
  (fn []
    (let [tree (require :nvim-tree)]
      (tree.setup
       {:diagnostics {:enable true}
        :select_prompts true
        :view {:mappings
               {:list [{:key "?" :action "toggle_help"}]}}
        :renderer {:group_empty true
                   :icons {:git_placement "after"
                           :glyphs {:default  ""
                                    :symlink  ""
                                    :bookmark "-"
                                    :git {:unstaged  ""
                                          :staged    "s"
                                          :unmerged  "="
                                          :renamed   "r"
                                          :untracked "u"
                                          :deleted   "d"
                                          :ignored   "!"}
                                    :folder {:arrow_closed ""
                                             :arrow_open   ""
                                             :default      ""
                                             :open         ""
                                             :empty        ""
                                             :empty_open   ""
                                             :symlink      ""
                                             :symlink_open ""}}}
                   :full_name true
                   :root_folder_label (if (has? "win32")
                                          (fn [path]
                                            (vim.fn.fnamemodify (vim.fs.normalize path)
                                                                ":~:s?$?/..?")))}})))}
 :nvim-tree/nvim-tree.lua)

(aucmd!
 (:group
  "nvimtree-bindings"
  Filetype
  :pattern "NvimTree"
  #(bind! "<ESC>" nb ":wincmd p<CR>")))
