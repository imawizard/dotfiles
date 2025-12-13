;; See :help which-key.txt.
{1 :folke/which-key.nvim
 :event :VeryLazy
 :keys [{1 "<Space>?"
         2 #((. (require :which-key) :show) {:global false})
         :desc "Buffer Local Keymaps (which-key)"}
        "<Space>"
        "<C-h>"
        "<C-x>"]
 :opts (fn []
         (let [wk (require :which-key)]
           (wk.add
             (icollect [k v (pairs _G.keybinds_groups)]
               {1 k :group v}))
           (vim.cmd
            "
            hi WhichKey guibg=#fff8dc
            hi WhichKeyBorder guibg=#fff8dc
            hi WhichKeyDesc guibg=#fff8dc
            hi WhichKeyGroup guibg=#fff8dc
            hi WhichKeyNormal guibg=#fff8dc
            hi WhichKeySeparator guibg=#fff8dc
            hi WhichKeyTitle guibg=#fff8dc
            hi WhichKeyValue guibg=#fff8dc
           "))

         {:delay     0
          :preset    "helix"
          :show_help false
          :replace   {:key [[:<Space> "SPC"]
                            [:<CR>    "RET"]
                            [:<Tab>   "TAB"]
                            [:<Esc>   "ESC"]
                            [:<BS>    "BS"]
                            (fn [key]
                              (let [wk (require :which-key.view)]
                                (wk.format key)))]}
          :plugins {:marks     true
                    :registers true
                    :spelling  {:enabled     true
                                :suggestions 20}
                    :presets   {:operators    false
                                :motions      false
                                :text_objects false
                                :windows      false
                                :nav          false
                                :z            false
                                :g            false}}
          :icons {:separator  ""
                  :breadcrumb "›"
                  :group      ""
                  :mappings   false}
          :layout {:spacing 6}})}

