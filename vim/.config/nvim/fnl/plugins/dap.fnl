(import-macros {: use!} :macros)

(use!
 ;; See :help dap.txt.
 {:config
  (fn []
    (vim.fn.sign_define "DapBreakpoint"          {:numhl "DiagnosticSignHint"})
    (vim.fn.sign_define "DapBreakpointCondition" {:numhl "DiagnosticSignHint"})
    (vim.fn.sign_define "DapLogPoint"            {:numhl "DiagnosticSignHint"})
    (vim.fn.sign_define "DapStopped"             {:numhl "DiagnosticSignHint"})
    (vim.fn.sign_define "DapBreakpointRejected"  {:numhl "DiagnosticSignHint"}))}
 :mfussenegger/nvim-dap

 ;; See :help nvim-dap-ui.
 {:config
  (fn []
    (let [dap (require :dap)
          dapui (require :dapui)]
      (dapui.setup)
      (set dap.listeners.after.event_initialized.dapui
           (fn []
             (dapui.open)))
      (set dap.listeners.after.event_terminated.dapui
           (fn []
             (dapui.close)))
      (set dap.listeners.after.event_exited.dapui
           (fn []
             (dapui.close)))))}
 :rcarriga/nvim-dap-ui

 {:config
  (fn []
    (let [dapvt (require :nvim-dap-virtual-text)]
      (dapvt.setup {:commented true})))}
 :theHamsta/nvim-dap-virtual-text)
