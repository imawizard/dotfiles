{1 :ibhagwan/fzf-lua
 :dependencies [:nvim-tree/nvim-web-devicons]
 :opts (fn []
         {1 [:ivy :hide]
          :winopts {:split "enew"}
          ; reset on every input change
          :fzf_args "--bind=change:first"})}
