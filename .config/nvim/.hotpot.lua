local allowed_globals = {}
for key, _ in pairs(_G) do
    table.insert(allowed_globals, key)
end

return {
    build = {
        {"fnl/plugins/**/*.fnl", true},
        {"fnl/langs/**/*.fnl", function(path)
            return path:gsub("/fnl/langs/", "/lua/plugins/langs/"):gsub("fnl$", "lua")
        end},
    },
    clean = true,
    compiler = {
        modules = {
            allowedGlobals = allowed_globals,
        },
    },
}
