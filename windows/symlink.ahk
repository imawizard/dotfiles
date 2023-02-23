Link(A_ScriptDir "\..\broot\.config\broot\*",      EnvGet("APPDATA") "\dystroy\broot\config")
Link(A_ScriptDir "\..\helix\.config\helix\*",      EnvGet("APPDATA") "\helix")
Link(A_ScriptDir "\..\helix\.config\helix\themes", EnvGet("APPDATA") "\helix\themes")
Link(A_ScriptDir "\..\wezterm\*",                  EnvGet("HOME"))

Link(A_ScriptDir "\..\nvim\.config\nvim\*",        EnvGet("LOCALAPPDATA") "\nvim")
Link(A_ScriptDir "\..\nvim\.config\nvim\fnl",      EnvGet("LOCALAPPDATA") "\nvim\fnl")
Link(A_ScriptDir "\..\nvim\.config\nvim\colors",   EnvGet("LOCALAPPDATA") "\nvim\colors")

Link(A_ScriptDir "\..\vim\*",                      EnvGet("HOME"))
Link(A_ScriptDir "\..\vim\.vim\autoload",          EnvGet("HOME") "\.vim\autoload")
Link(A_ScriptDir "\..\vim\.vim\colors",            EnvGet("HOME") "\.vim\colors")
Link(EnvGet("HOME") "\.vim",                       EnvGet("HOME") "\vimfiles")

Link(A_ScriptDir "\..\windows\PowerShell\*",       A_MyDocuments "\PowerShell")
Link(A_ScriptDir "\..\windows\PowerToys\**",       EnvGet("LOCALAPPDATA") "\Microsoft\PowerToys")
Link(A_ScriptDir "\..\windows\WindowsTerminal\*",  EnvGet("LOCALAPPDATA") "\Microsoft\Windows Terminal")

; If `from` is the path of a directory or a file, a symlink is created at
; destination `to`. If it ends in an asterisk, all files found on the first
; level under `from` are symlinked at the destination. If it ends in two
; asterisks, all files found recursively are symlinked.
Link(from, to) {
    if SubStr(from, -1) != "*" {
        attr := FileExist(from)
        if attr {
            opts := InStr(attr, "D") ? "/D" : ""
            SplitPath(to, , &dirname)
            DirCreate(dirname)
            Run(A_ComSpec " /c mklink " opts " `"" to "`" `"" from "`"", , "Hide")

        }
    } else {
        SplitPath(from, , &dirname)
        loop files from, SubStr(from, -2) == "**" ? "R" : "" {
            relPath := StrSplit(A_LoopFileDir, dirname)[2]
            DirCreate(to relPath)
            Link(A_LoopFileFullPath, to relPath "\" A_LoopFileName)
        }
    }
}
