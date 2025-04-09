(import-macros {: bind!} :macros)

{1 :smoka7/hop.nvim
 :keys [{1 "go" :mode [:n :x]}]
 :opts (fn []
         (let [hop (require "hop")]
           (bind!
            :desc "Jump somewhere" "go" nx #(hop.hint_words)))
         {})}
