(import-macros {: bind! : feedkeys!} :macros)

(bind!
 (:when (not= (os.getenv "VIM_CUSTOM_KEYBINDS") nil)
   ;; Like tmux's break-pane binding.
   "<C-w>!" n "<C-w>T"

   ;; Same C-m (Return) as in insert mode.
   "<CR>" n "o<ESC>"

   ;; Same C-j as in Emacs.
   "<C-j>" n "i<CR><ESC>"

   :desc "Previous change"     "[c"       ne "&diff ? '[c' : ':Gitsigns prev_hunk<CR>'"
   :desc "Next change"         "]c"       ne "&diff ? ']c' : ':Gitsigns next_hunk<CR>'"

   :desc "Set breakpoint"      "<F2>"     n  #((. (require :dap) :toggle_breakpoint))
   :desc "Terminate"           "<C-S-F2>" n  #((. (require :dap) :terminate))
   :desc "Step out"            "<S-F9>"   n  #((. (require :dap) :step_out))
   :desc "Step into"           "<F7>"     n  #((. (require :dap) :step_into))
   :desc "Step over"           "<F8>"     n  #((. (require :dap) :step_over))
   :desc "Run"                 "<F9>"     n  #((. (require :dap) :continue))))
