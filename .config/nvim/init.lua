vim.loader.enable()

vim.opt.runtimepath:prepend({
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
    vim.fn.stdpath("data") .. "/lazy/hotpot.nvim",
})

-- See :help hotpot
local hotpot = require("hotpot")
hotpot.setup({
    compiler = {
        modules = {
            correlate = true
        },
    },
})

-- Compile fnl-files using .hotpot.lua for lazy.nvim
hotpot.api.make.auto.build(vim.fn.stdpath("config"), {
    verbose = false,
    force = false,
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
