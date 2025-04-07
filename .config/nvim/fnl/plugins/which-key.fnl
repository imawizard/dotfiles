;; See :help which-key.txt.
{1 :folke/which-key.nvim
 :event :VeryLazy
 :keys [{1 "<Space>?"
         2 #((. (require :which-key) :show) {:global false})
         :desc "Buffer Local Keymaps (which-key)"}
        "<Space>"
        "<C-h>"
        "<C-x>"]
 :opts {:delay     0
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
        :layout {:spacing 6}}
 :init #(let [wk (require :which-key)]
          (wk.add [{1 :<Space>   :group "SPC"}
                   {1 :<Space>b  :group "Buffer"}
                   {1 :<Space>c  :group "Code"}
                   {1 :<Space>cl :group "Lsp"}
                   {1 :<Space>e  :group "Eval"}
                   {1 :<Space>f  :group "File"}
                   {1 :<Space>g  :group "Git"}
                   {1 :<Space>gc :group "Create"}
                   {1 :<Space>gf :group "Find"}
                   {1 :<Space>i  :group "Insert"}
                   {1 :<Space>n  :group "Number"}
                   {1 :<Space>o  :group "Open"}
                   {1 :<Space>p  :group "Project"}
                   {1 :<Space>q  :group "Quit"}
                   {1 :<Space>r  :group "Run"}
                   {1 :<Space>s  :group "Search"}
                   {1 :<Space>t  :group "Toggle"}
                   {1 :<Space>ti :group "Indentation"}
                   {1 :<Space>w  :group "Workspace"}
                   {1 "<Space>@" :group "History"}
                   {1 :<C-h>     :group "Help"}
                   {1 :<C-h>b    :group "Bindings"}
                   {1 :<C-h>h    :group "Highlights"}
                   {1 :<C-h>r    :group "Reload"}
                   {1 :<C-x>     :group "Completion" :mode :i}
                   {1 :g         :group "Goto"}])
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
           "))}

