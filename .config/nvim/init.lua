vim.loader.enable()

vim.opt.runtimepath:prepend({
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
    vim.fn.stdpath("data") .. "/lazy/hotpot.nvim",
})

-- See :help hotpot
require("hotpot").setup({
    compiler = {
        modules = {
            correlate = true
        },
    },
})

-- See :help lazy
require("lazy").setup({
    spec = {
        {"rktjmp/hotpot.nvim"},
        {import = "plugins"},
    },
})

package.loaded["main"] = nil
require("main")
