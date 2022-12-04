;;(import-macros {: use!} :macros)
;;
;;(use!
;; ;; See :help nvim-autopairs.txt and :help nvim-autopairs-rules.txt.
;; {:config
;;  (fn []
;;    (let [autopairs (require :nvim-autopairs)
;;          autopairs_cmp (require :nvim-autopairs.completion.cmp)
;;          cmp (require :cmp)
;;          Rule (require :nvim-autopairs.rule)
;;          conds (require :nvim-autopairs.conds)]
;;
;;      (autopairs.setup {:map_c_h true
;;                        :map_c_w true})
;;
;;      (if (not= cmp nil)
;;          (cmp.event:on "confirm_done" (autopairs_cmp.on_confirm_done)))))}
;; :windwp/nvim-autopairs)

;:ignored_next_char (string.gsub "[%s]* [%w%%%'%[%{%\"%.]" "%s+" "")
;(autopairs.clear_rules)
;;-- Don't autopair ' when in a .tex file
;;npairs.get_rule("'")[1]:with_pair(function()
;;    if vim.bo.filetype == "tex" then
;;        return false
;;    end
;;end)
;;
;;-- Don't autopair " when in a .tex file
;;npairs.get_rule('"')[1]:with_pair(function()
;;    if vim.bo.filetype == "tex" then
;;        return false
;;    end
;;end)
