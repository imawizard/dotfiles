-- See :help hotpot
require("hotpot").setup({
    provide_require_fennel = true,
    compiler = {
        modules = {
            correlate = true
        },
    }
})

package.loaded["main"] = nil
require("main")
