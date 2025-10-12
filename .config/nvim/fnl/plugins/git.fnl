(import-macros {: gset! : aucmd! : bind!} :macros)

(gset!
 git_messenger_no_default_mappings true
 git_messenger_always_into_popup true
 git_messenger_floating_win_opts {:border "single"}

 gitblame_highlight_group "CursorLine"
 gitblame_use_blame_commit_file_urls false)

(aucmd!
 (:group
  "gitmessenger-bindings"
  Filetype
  :pattern "gitmessengerpopup"
  (fn []
    (bind!
     "<Esc>" nrb "q"
     "<C-o>" nrb "o"
     "<C-i>" nrb "O"))))

[
 ;; See :help gitsigns.nvim.
 {1 :lewis6991/gitsigns.nvim
  :event :VeryLazy}

 ;; Sophisticated diff viewer, see :help diffview-config-keymaps
 ;;                            and :help diffview-actions.
 {1 :sindrets/diffview.nvim
  :cmd [:DiffviewOpen
        :DiffviewFileHistory]}

 {1 :rhysd/git-messenger.vim
  :cmd [:GitMessenger]}

 ;; Show inline blame.
 {1 :f-person/git-blame.nvim
  :event :VeryLazy
  :opts
  {:message_template "       <author>, <date>"
   :date_format "%r"}}]

