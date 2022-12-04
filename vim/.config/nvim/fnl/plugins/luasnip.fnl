(import-macros {: use!} :macros)

(use!
 ;; See :help luasnip.txt.
 {:config
  (fn []
    (let [ls (require :luasnip)
          snip (require :luasnip.loaders.from_lua)
          types (require :luasnip.util.types)]
      (ls.setup {})
      (snip.load)))}
 :L3MON4D3/LuaSnip)

(fn _G.luasnip_edit_snippets []
  (let [snip (require :luasnip.loaders)]
    (snip.edit_snippet_files
     {:edit (fn [path]
              (vim.cmd (.. "edit "
                           (string.gsub (string.gsub path "%.lua$" ".fnl")
                                        "([/\\])luasnippets%1"
                                        "%1fnl%1snippets%1"))))})))
