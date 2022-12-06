(import-macros {: use! : aucmd!} :macros)

(use!
 ;; See :help lspconfig.txt and :help lspconfig-all.
 :neovim/nvim-lspconfig)

(let [hilite-augrp "lsp-doc-highlight"]
  (aucmd!
   (:group
    "lsp-on-attach"
    LspAttach
    (fn [args]
      (when (_G.lsp? :documentHighlightProvider args.buf)
        (aucmd!
         (:group
          (.. hilite-augrp "-" args.buf)
          ;; Highlight identifier under cursor.
          [CursorHold CursorHoldI]
          :buffer args.buf
          #(vim.lsp.buf.document_highlight)
          CursorMoved
          :buffer args.buf
          #(vim.lsp.buf.clear_references))))))
   (:group
    "lsp-on-detach"
    LspDetach
    (fn [args]
      (when (not (_G.lsp? :documentHighlightProvider args.buf))
        (pcall #(vim.api.nvim_del_augroup_by_name
                 (.. hilite-augrp "-" args.buf))))))))

(fn _G.lsp? [capability bufnr]
  (_G.lsp-any #(not= (. $1 capability) nil) bufnr))

(fn _G.lsp-organize-imports? [bufnr]
  (_G.lsp-any
   (fn [caps]
     (var found false)
     (let [actions (?. caps :codeActionProvider :codeActionKinds)]
       (each [_ action (ipairs (or actions []))
              &until (not= found false)]
         (if (= action "source.organizeImports")
             (set found true))))
     found)
   bufnr))

(fn _G.lsp-organize-imports! []
  (let [params (vim.lsp.util.make_range_params)]
    (set params.context {:only ["source.organizeImports"]})
    (each [client res (pairs
                       (or (vim.lsp.buf_request_sync
                            0 "textDocument/codeAction" params 500) {}))]
      (each [_ r (pairs (or res.result {}))]
        (let [enc (or (. (or (vim.lsp.get_client_by_id client) {})
                         :offset_encoding)
                      "utf-16")]
          (if (not= r.edit nil)
              (vim.lsp.util.apply_workspace_edit r.edit enc)
              (not= r.command nil)
              (vim.lsp.buf.execute_command r.command enc)))))))

(fn _G.lsp-any [cb bufnr]
  (var found false)
  (let [bufnr (or bufnr (vim.fn.bufnr))
        clients (vim.lsp.get_active_clients {:bufnr bufnr})]
    (each [_ client (ipairs clients)
           &until (not= found false)]
      (let [caps client.server_capabilities]
        (if (cb caps)
            (set found true)))))
  found)
