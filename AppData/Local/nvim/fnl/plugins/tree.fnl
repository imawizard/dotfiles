(import-macros {: gset! : use! : aucmd! : bind! : has?} :macros)

(gset!
 loaded_netrw       true
 loaded_netrwPlugin true)

(use!
 ;; Similiar to NERDTree, see :help nvim-tree.lua.
 {:requires [:nvim-lua/plenary.nvim
             :nvim-tree/nvim-web-devicons]
  :config
  (fn []
    (let [tree (require :nvim-tree)
          api (require :nvim-tree.api)]

      (tree.setup
       {:respect_buf_cwd true
        :diagnostics {:enable true}
        :git {:ignore false}
        :select_prompts true
        :remove_keymaps ["g?" "s"]
        :view {:hide_root_folder true
               :mappings {:list [{:key "<CR>"
                                  :action "open file and close tree"
                                  :action_cb #(do (api.node.open.no_window_picker)
                                                  (api.tree.close))}
                                 {:key "<ESC>"
                                  :action "focus previous window"
                                  :action_cb #(vim.cmd "wincmd p")}
                                 {:key "o"    :action "edit_no_picker"}
                                 {:key "O"    :action "edit"}
                                 {:key "?"    :action "toggle_help"}
                                 {:key "!"    :action "system_open"}]}}
        :renderer {:group_empty true
                   :icons {:glyphs {:default  ""
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
                   :root_folder_label (if (has? "win32")
                                          (let [home-pat (.. "^" (vim.fs.normalize vim.env.HOME))]
                                            (fn [path]
                                              (string.gsub (vim.fs.normalize path)
                                                           home-pat
                                                           "~"))))}
        :filesystem_watchers {:ignore_dirs
                              ["[/\\\\].git$"
                               "[/\\\\]node_modules$"
                               "[/\\\\]target$"]}})))}
 :nvim-tree/nvim-tree.lua)
