(import-macros {: bind! : feedkeys!} :macros)

(bind!
 ;; Like tmux's break-pane binding.
 "<C-w>!" n "<C-w>T"

 :desc "Previous change"     "[c"       ne "&diff ? '[c' : ':Gitsigns prev_hunk<CR>'"
 :desc "Next change"         "]c"       ne "&diff ? ']c' : ':Gitsigns next_hunk<CR>'"

 :desc "Set breakpoint"      "<F2>"     n  #((. (require :dap) :toggle_breakpoint))
 :desc "Terminate"           "<C-S-F2>" n  #((. (require :dap) :terminate))
 :desc "Step out"            "<S-F9>"   n  #((. (require :dap) :step_out))
 :desc "Step into"           "<F7>"     n  #((. (require :dap) :step_into))
 :desc "Step over"           "<F8>"     n  #((. (require :dap) :step_over))
 :desc "Run"                 "<F9>"     n  #((. (require :dap) :continue)))
