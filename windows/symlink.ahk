Link(A_ScriptDir "\..\vim\.vimrc",           EnvGet("HOME") "\.vimrc")
Link(A_ScriptDir "\..\vim\.vim\colors",      EnvGet("LOCALAPPDATA") "\nvim\colors")
Link(A_ScriptDir "\..\vim\.config\nvim\*",   EnvGet("LOCALAPPDATA") "\nvim")
Link(A_ScriptDir "\..\vim\.config\nvim\fnl", EnvGet("LOCALAPPDATA") "\nvim\fnl")
Link(A_ScriptDir "\..\windows\PowerShell\*", A_MyDocuments "\PowerShell")

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
        loop files from {
            relPath := StrSplit(A_LoopFileDir, dirname)[2]
            DirCreate(to relPath)
            Link(A_LoopFileFullPath, to relPath "\" A_LoopFileName)
        }
    }
}
