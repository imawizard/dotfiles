(import-macros {: use! : gset!} :macros)

(use!
 ;; Search and replace with rg, see :help ctrlsf.txt.
 :dyng/ctrlsf.vim)

(gset!
 ctrlsf_winsize          "40%"
 ctrlsf_position         "bottom" ; Open below.
 ctrlsf_preview_position "inside" ; Open preview as split.
 ctrlsf_context          "-B 2"   ; Print that many lines for context.

 ctrlsf_extra_backend_args {:rg ["--hidden"
                                 "-g" "!.git/"]}

 ctrlsf_auto_focus {:at "done"
                    :duration_less_than 1000})
