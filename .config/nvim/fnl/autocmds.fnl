(import-macros {: aucmd! : feedkeys! : bind!} :macros)

(aucmd!
 (:group
  :reload-config
  ;; Reload config on changes.
  BufWritePost
  :pattern "*/nvim/fnl/*.fnl"
  #(_G.require_forcefully
    (_G.get_module_if_part_of_main_config
     (vim.fn.expand "<afile>:p"))))

 (:group
  :highlight-on-yank
  ;; Highlight yanks.
  TextYankPost
  #(vim.hl.on_yank {:higroup "HighlightedyankRegion"
                    :timeout 400}))

 (:group
  :close-preview-after-completion
  ;; Close any popup windows if no popup menu is open.
  [InsertLeave CompleteDone]
  #(when (= (vim.fn.pumvisible) 0)
     (vim.cmd "silent! pclose")))

 (:group
  :autosave-like-intellij
  ;; Save automatically.
  [WinLeave FocusLost]
  "silent! wall")

 (:group
  :restore-C-m-if-readonly
  ;; CR is remapped to insert a line, restore it conditionally.
  BufReadPost
  #(when (not vim.bo.modifiable)
     (bind! "<CR>" nb "<CR>")))

 (:group
  :add-cwd-to-zoxide
  ;; Analogous to cd-hook in terminal.
  DirChanged
  #(vim.fn.system ["zoxide" "add" (vim.fn.expand "<afile>")]))

 (:group
  :default-filetype
  ;; Start new buffers as text.
  [BufNew VimEnter]
  (fn [args]
   (when (and (= "" (. vim.bo args.buf :filetype))
              (= "" (vim.api.nvim_buf_get_name args.buf)))
     (tset (. vim.bo args.buf) :filetype "text")))))
