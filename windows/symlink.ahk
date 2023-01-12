Link(A_ScriptDir "\..\vim\*",                     EnvGet("HOME"))
Link(A_ScriptDir "\..\vim\.vim\autoload",         EnvGet("HOME") "\vimfiles\autoload")
Link(A_ScriptDir "\..\vim\.vim\colors",           EnvGet("HOME") "\vimfiles\colors")
Link(A_ScriptDir "\..\nvim\.config\nvim\**",      EnvGet("LOCALAPPDATA") "\nvim")
Link(A_ScriptDir "\..\nvim\.config\nvim\fnl",     EnvGet("LOCALAPPDATA") "\nvim\fnl")
Link(A_ScriptDir "\..\nvim\.config\nvim\colors",  EnvGet("LOCALAPPDATA") "\nvim\colors")
Link(A_ScriptDir "\..\windows\PowerShell\*",      A_MyDocuments "\PowerShell")
Link(A_ScriptDir "\..\windows\PowerToys\**",      EnvGet("LOCALAPPDATA") "\Microsoft\PowerToys")
Link(A_ScriptDir "\..\windows\WindowsTerminal\*", EnvGet("LOCALAPPDATA") "\Microsoft\Windows Terminal")

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
