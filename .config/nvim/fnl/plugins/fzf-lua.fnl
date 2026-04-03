{1 :ibhagwan/fzf-lua
 :dependencies [:nvim-tree/nvim-web-devicons]
 :opts (fn []
         {1 [:ivy :hide]
          :winopts {:split "enew"}
          ; reset position on every input change
          :fzf_args "--bind=change:first"
          :files {:no_ignore false}
          :grep {:no_ignore false}})}
          ; :actions {:files {"alt-f" FzfLua.actions.file_edit_or_qf}}})}
          ;                   1 false
          ;                   :ctrl-s _G.FzfLua.actions.file_edit_or_qf}}})}
    ;   --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
    ;   --   tags, btags, args, buffers, tabs, lines, blines
    ;   -- `file_edit_or_qf` opens a single selection or sends multiple selection to quickfix
    ;   -- replace `enter` with `file_edit` to open all files/bufs whether single or multiple
    ;   -- replace `enter` with `file_switch_or_edit` to attempt a switch in current tab first
    ;   ["enter"]       = FzfLua.actions.file_edit_or_qf,
    ;   ["ctrl-s"]      = FzfLua.actions.file_split,
    ;   ["ctrl-v"]      = FzfLua.actions.file_vsplit,
    ;   ["ctrl-t"]      = FzfLua.actions.file_tabedit,
    ;   ["alt-q"]       = FzfLua.actions.file_sel_to_qf,
    ;   ["alt-Q"]       = FzfLua.actions.file_sel_to_ll,
    ;   ["alt-i"]       = FzfLua.actions.toggle_ignore,
    ;   ["alt-h"]       = FzfLua.actions.toggle_hidden,
    ;   ["alt-f"]       = FzfLua.actions.toggle_follow,
    ; },}
