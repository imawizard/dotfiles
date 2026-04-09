vim.loader.enable()

vim.opt.runtimepath:prepend({
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
    vim.fn.stdpath("data") .. "/lazy/hotpot.nvim",
})

-- Set colorscheme
vim.o.background = "light"
vim.cmd("colorscheme bold-intellij-light")

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
        {import = "plugins/langs"},
    },
})

-- Return the module name if path denotes a part of the main config
-- i.e. no plugins for lazy, no macros for fennel, no snippets
function _G.get_module_if_part_of_main_config(path)
    local prefix = vim.fn.stdpath("config") .. "/fnl"
    local m = vim.fn.fnamemodify(path:sub(prefix:len() + 2), ":r")
    for _, exclude in ipairs({
        "^plugins/",
        "^langs/",
        "^lsp/",
        "^snippets/",
        "macros$",
    }) do
        if m:match(exclude) then
            return nil
        end
    end
    return m
end

-- Load module without using cache
function _G.require_forcefully(m)
    if m then
        package.loaded[m] = nil
        pcall(require(m))
    end
end

-- Load the main config fnl-files
for _, v in ipairs(
    vim.fn.glob(vim.fn.stdpath("config") .. "/fnl/**/*.fnl", false, true)
) do
    _G.require_forcefully(_G.get_module_if_part_of_main_config(v))
end

vim.cmd([[
packadd nvim.undotree
packadd nvim.difftool
]])

vim.lsp.enable("tsgo")
vim.lsp.enable("bashls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("buf_ls")
vim.lsp.enable("docker_language_server")
vim.lsp.enable("docker_compose_language_service")
vim.lsp.enable("gopls")
vim.lsp.enable("fennel_ls")


-- npm i -g bash-language-server
--
-- luacheck
--
-- vim-vint
-- yamllint
--
--    bash-language-server
--    dot-language-server
--    fixjson
--    perlnavigator-server
--    sql-formatter
--    sql-language-server
--    typescript
--    typescript-language-server
--    vim-language-server
--    vscode-langservers-extracted
--    yaml-language-server
