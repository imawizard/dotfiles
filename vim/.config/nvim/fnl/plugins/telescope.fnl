(import-macros {: use! : has?} :macros)

(use!
 ;; See :help telescope.nvim.
 {:requires [:nvim-lua/plenary.nvim
             :nvim-tree/nvim-web-devicons]
  :branch "0.1.x"
  :config
  (fn []
    (let [telescope (require :telescope)
          builtin (require :telescope.builtin)
          actions (require :telescope.actions)
          themes (require :telescope.themes)]
      (telescope.setup
       {:defaults
        ((. themes :get_ivy) {:mappings {:i {"<ESC>" actions.close
                                             "<C-^>" actions.which_key
                                             "<C-j>" actions.results_scrolling_down
                                             "<C-k>" actions.results_scrolling_up
                                             "<C-9>" actions.cycle_history_next
                                             "<C-0>" actions.cycle_history_prev
                                             "<C-BS>" {1 "<S-C-w>" :type "command"}}}
                              :vimgrep_arguments ["rg"
                                                  "--color=never"
                                                  "--no-heading"
                                                  "--with-filename"
                                                  "--line-number"
                                                  "--column"
                                                  "--smart-case"
                                                  "--hidden"
                                                  "-g" "!.git/"]
                              :dynamic_preview_title true
                              :results_title false
                              :path_display (if (has? "win32")
                                                (fn [opts path]
                                                  (vim.fs.normalize path)))})

        :pickers
        {:find_files {:hidden true
                      :find_command ["rg"
                                     "--files"
                                     "--color=never"
                                     "-g" "!.git/"]}}

        :extensions
        {:project {:hidden_files true
                   :theme "dropdown"
                   :sync_with_nvim_tree true}

         :zoxide {:mappings {:default
                             {:action (fn [selection]
                                        (vim.cmd
                                         (.. "tcd " selection.path)))}}}}})))}
 :nvim-telescope/telescope.nvim
 :nvim-telescope/telescope-symbols.nvim

 {:run "make"
  :config
  (fn []
    (let [telescope (require :telescope)
          config (require :telescope.config)]
      (telescope.load_extension "fzf")))}
 :nvim-telescope/telescope-fzf-native.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "ui-select")))}
 :nvim-telescope/telescope-ui-select.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "packer")))}
 :nvim-telescope/telescope-packer.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "dap")))}
 :nvim-telescope/telescope-dap.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "project")))}
 :nvim-telescope/telescope-project.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "luasnip")))}
 :benfowler/telescope-luasnip.nvim

 {:config
  (fn []
    (let [telescope (require :telescope)]
      (telescope.load_extension "zoxide")))}
 :jvgrootveld/telescope-zoxide)

(fn _G.oldfiles_tiebreak []
  (let [curbufid (vim.api.nvim_get_current_buf)
        curfile (vim.fs.normalize (vim.api.nvim_buf_get_name curbufid))
        recency {}]
    (var n 0)
    (each [_ buf (ipairs (vim.split (vim.fn.trim (vim.fn.execute ":buffers! t")) "\n"))]
      (let [bufid (tonumber (string.match buf "%s*(%d+)"))]
        (if (= (string.match buf " 0$") nil)
            (let [file (vim.fs.normalize (vim.api.nvim_buf_get_name bufid))]
              (when (and (and (not= bufid curbufid)
                              (not= file ""))
                         (vim.loop.fs_stat file))
                (tset recency file n)
                (set n (+ n 1)))))))
    (each [_ file (ipairs vim.v.oldfiles)]
      (let [file (vim.fs.normalize file)]
        (when (and (and (vim.loop.fs_stat file)
                        (= (. recency file) nil))
                   (not= file curfile))
          (tset recency  file n)
          (set n (+ n 1)))))
    (fn [b a prompt]
      (let [a_path (vim.fs.normalize a.path)
            b_path (vim.fs.normalize b.path)]
        (let [diff (- (or (. recency b_path) math.huge)
                      (or (. recency a_path) math.huge))]
            (if (not= diff 0) (< diff 0)
                (< (# b.ordinal) (# a.ordinal))))))))
