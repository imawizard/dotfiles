;; Print color-values in color, see :help colorizer.
{1 :catgoose/nvim-colorizer.lua
 :event :VeryLazy
 :opts {"*" {:RGB      true
             :RRGGBB   true
             :names    true
             :RRGGBBAA true
             :html {:css true}
             :css  {:css true}}
        :lazy_load true}}
