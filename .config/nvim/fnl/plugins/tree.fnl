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
        :on_attach (fn []
                     (bind!
                      :desc "open file and close tree" "<CR>" n #(do (api.node.open.no_window_picker)
                                                                     (api.tree.close))
                      :desc "focus previous window" "<ESC>" n #(vim.cmd "wincmd p")
                      "o" n #(api.node.open.no_window_picker)
                      "O" n #(api.node.open.edit)
                      "?" n #(api.tree.toggle_help)
                      "!" n #(api.node.run.system)))
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
