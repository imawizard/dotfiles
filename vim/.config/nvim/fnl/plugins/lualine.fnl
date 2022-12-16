(import-macros {: use! : oset! : has?} :macros)

(use!
 ;; See :help lualine.txt.
 {:requires [:nvim-tree/nvim-web-devicons]
  :config
  (fn []
    (let [lualine (require :lualine)]

      (fn fileformat []
        (let [b vim.bo]
          (.. (match b.fileformat
                "unix" "lf"
                "dos" "crlf"
                _ "cr")
              " "
              b.shiftwidth
              (if b.expandtab "sp" "tb")
              (if (not= b.shiftwidth b.tabstop)
                  b.tabstop
                  ""))))

      (fn progress []
        (let [cur (vim.fn.line ".")
              total (vim.fn.line "$")
              pct (math.floor (* (/ cur total) 100))]
          (.. pct "%%")))

      (fn cwd []
        (let [home-pat (.. "^" (vim.fs.normalize vim.env.HOME))]
          #(string.gsub (vim.fs.normalize (vim.fn.getcwd))
                        home-pat
                        "~/")))

      (fn gutentags []
        (when vim.fn.gutentags#statusline
          (vim.fn.gutentags#statusline "[" "]")))

      (lualine.setup
       {:options {:theme
                  {:normal   {:a {:fg "#fafafa" :bg "#98c379" :gui "bold"}
                              :b {:fg "#494b53" :bg "#d0d0d0"}
                              :c {:fg "#494b53" :bg "#f0f0f0"}}
                   :inactive {:a {:fg "#fafafa" :bg "#d0d0d0"}
                              :b {:fg "#fafafa" :bg "#d0d0d0"}
                              :c {:fg "#d0d0d0" :bg "#f0f0f0"}}
                   :command  {:a {:fg "#fafafa" :bg "#8BBCCC" :gui "bold"}}
                   :insert   {:a {:fg "#fafafa" :bg "#61afef" :gui "bold"}}
                   :visual   {:a {:fg "#fafafa" :bg "#c678dd" :gui "bold"}}
                   :replace  {:a {:fg "#fafafa" :bg "#e06c75" :gui "bold"}}}
                  :icons_enabled false
                  :component_separators ""
                  :section_separators ""
                  :disabled_filetypes {:statusline []
                                       :winbar []}
                  :ignore_focus []
                  :always_divide_middle true
                  :refresh {:statusline 1000
                            :tabline 1000
                            :winbar 1000}}
        :sections {:lualine_a ["mode"]
                   :lualine_b [{1 "branch"
                                :separator "|"
                                :icons_enabled true
                                :icon ""}
                               "filename"]
                   :lualine_c ["location"
                               {1 "diff"
                                :diff_color {:added {:fg "#be5046"}
                                             :modified {:fg "#e5c07b"}
                                             :removed {:fg "#bee6be"}}}]
                   :lualine_x [gutentags "diagnostics"
                               {1 progress
                                :padding {:left 0 :right 1}}]
                   :lualine_y [{1 fileformat
                                :separator "|"}
                               {1 "encoding"
                                :separator "|"}]
                   :lualine_z ["filetype"]}
        :inactive_sections {:lualine_a []
                            :lualine_b []
                            :lualine_c ["filename"]
                            :lualine_x ["location"]
                            :lualine_y []
                            :lualine_z []}
        :tabline {:lualine_a [{1 "tabs"
                               :mode 1
                               :max_length vim.o.columns
                               :padding {:left 0 :right 1}
                               :tabs_color {:active {:fg "#fafafa"
                                                     :bg "#c678dd"
                                                     :gui "bold"}
                                            :inactive {:fg "#494b53"
                                                       :bg "#d0d0d0"}}}]
                  :lualine_b []
                  :lualine_c []
                  :lualine_x [(cwd)]
                  :lualine_y []
                  :lualine_z []}
        :winbar {}
        :inactive_winbar {}
        :extensions ["man"
                     "nvim-dap-ui"
                     (if (has? "win32")
                         {:sections {:lualine_a [(cwd)]}
                          :filetypes ["NvimTree"]}
                         "nvimtree")
                     "quickfix"
                     "symbols-outline"
                     "toggleterm"]})

      ;; Add folder to a tab's title.
      (let [Tab (require :lualine.components.tabs.tab)]
        (when (not Tab.label-orig)
          (set Tab.label-orig Tab.label))
        (fn Tab.label [self]
          (let [winnr (vim.fn.tabpagewinnr self.tabnr)
                modified (vim.fn.gettabwinvar self.tabnr winnr "&modified")
                label (.. (Tab.label-orig self)
                          (if (= modified 1) " +" ""))
                wd (vim.fn.fnamemodify (vim.fn.getcwd -1 self.tabnr) ":~:t")
                activeTab (vim.fn.tabpagenr)]
            (.. (if (and (> self.tabnr 1)
                         (not= activeTab self.tabnr)
                         (not= activeTab (- self.tabnr 1))) "| " " ")
                self.tabnr
                " "
                label
                (if (not= wd "")
                    (.. " - " wd))))))))}
 :nvim-lualine/lualine.nvim)

(oset!
 showmode false)
