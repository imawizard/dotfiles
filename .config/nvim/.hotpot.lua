local allowed_globals = {}
for key, _ in pairs(_G) do
    table.insert(allowed_globals, key)
end

return {
    build = {
        {"fnl/plugins/**/*.fnl", true},
    },
    clean = true,
    compiler = {
        modules = {
            allowedGlobals = allowed_globals,
        },
    },
}
