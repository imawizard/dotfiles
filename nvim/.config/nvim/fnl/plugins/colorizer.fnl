(import-macros {: use!} :macros)

(use!
 ;; Print color-values in color, see :help colorizer.
 {:config
  (fn []
    (let [colorizer (require :colorizer)]
      (colorizer.setup {"*" {:RGB      true
                             :RRGGBB   true
                             :names    true
                             :RRGGBBAA true
                             :html {:css true}
                             :css  {:css true}}})))
  :event :VimEnter}
 :NvChad/nvim-colorizer.lua)
