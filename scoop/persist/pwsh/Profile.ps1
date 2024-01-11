# PSReadLine
# See https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1
Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None

Set-PSReadLineKeyHandler -Key "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+LeftArrow"  -Function BackwardWord
Set-PSReadLineKeyHandler -Key "Ctrl+Backspace"  -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Key "Ctrl+Delete"     -Function DeleteWord
Set-PSReadLineKeyHandler -Key "Ctrl+_"          -Function Undo
Set-PSReadLineKeyHandler -Key "Ctrl+e"          -ScriptBlock {
    Param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine($key, $arg)
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion($key, $arg)
    }
}

# Theme
# See https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-light-theme?view=powershell-7.3
$ISETheme = @{
    Default                = $PSStyle.Foreground.FromRGB(0x0000ff)
    Command                = $PSStyle.Foreground.FromRGB(0x0000ff)
    Selection              = $PSStyle.Background.FromRGB(0x00bfff)
    ContinuationPrompt     = $PSStyle.Foreground.FromRGB(0x0000ff)

    Keyword                = $PSStyle.Foreground.FromRGB(0x00008b)
    Operator               = $PSStyle.Foreground.FromRGB(0x757575)
    Type                   = $PSStyle.Foreground.FromRGB(0x008080)
    Number                 = $PSStyle.Foreground.FromRGB(0x800080)
    String                 = $PSStyle.Foreground.FromRGB(0x8b0000)
    Comment                = $PSStyle.Foreground.FromRGB(0x006400)

    Variable               = $PSStyle.Foreground.FromRGB(0xff4500)
    Parameter              = $PSStyle.Foreground.FromRGB(0x000080)
    Member                 = $PSStyle.Foreground.FromRGB(0x000000)

    Error                  = $PSStyle.Foreground.FromRGB(0xe50000)
    Emphasis               = $PSStyle.Foreground.FromRGB(0x287bf0)
    InlinePrediction       = $PSStyle.Foreground.FromRGB(0x93a1a1)
    ListPrediction         = $PSStyle.Foreground.FromRGB(0x06de00)
    ListPredictionSelected = $PSStyle.Background.FromRGB(0x93a1a1)
}
Set-PSReadLineOption -Colors $ISETheme

$PSStyle.Formatting.FormatAccent       = "`e[32m"
$PSStyle.Formatting.TableHeader        = "`e[32m"
$PSStyle.Formatting.ErrorAccent        = "`e[36m"
$PSStyle.Formatting.Error              = "`e[31m"
$PSStyle.Formatting.Warning            = "`e[33m"
$PSStyle.Formatting.Verbose            = "`e[33m"
$PSStyle.Formatting.Debug              = "`e[33m"
$PSStyle.Progress.View                 = "Classic"
$PSStyle.Progress.Style                = "`e[33m"
$PSStyle.FileInfo.Directory            = "`e[34m"
$PSStyle.FileInfo.SymbolicLink         = "`e[36m"
$PSStyle.FileInfo.Executable           = "`e[95m"
$PSStyle.FileInfo.Extension[".ps1"]    = "`e[36m"
$PSStyle.FileInfo.Extension[".ps1xml"] = "`e[36m"
$PSStyle.FileInfo.Extension[".psd1"]   = "`e[36m"
$PSStyle.FileInfo.Extension[".psm1"]   = "`e[36m"

function Prompt {
    $cwd = $executionContext.SessionState.Path.CurrentLocation
    $osc7 = ""
    if ($cwd.Provider.Name -eq "FileSystem") {
        $esc = [char]27
        $path = $cwd.ProviderPath -Replace "\\", "/"
        $osc7 = "$esc]7;file://${env:COMPUTERNAME}/$path$esc\"
    }
    "${osc7}λ $cwd$('>' * $NestedPromptLevel) ";
}

# zoxide integration
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { "prompt" } else { "pwd" }
    (zoxide init --hook $hook powershell | Out-String)
})

# lazygit macro
function lg {
    $tmpfile = New-TemporaryFile
    try {
        $env:LAZYGIT_NEW_DIR_FILE = $tmpfile
        $lazygit = $env:LAZYGIT
        if (-not $lazygit) {
             $lazygit = 'lazygit'
        }
        & $lazygit $args
        if ($LASTEXITCODE -ne 0) {
            Write-Error "lazygit exited with code $LASTEXITCODE"
            return
        }
        $path = Get-Content $tmpfile
        if ($path) {
            cd $path
        }
    } finally {
        Remove-Item -force $tmpfile
        $env:LAZYGIT_NEW_DIR_FILE = ""
    }
}

# broot macro
# See https://github.com/Canop/broot/issues/159
function br {
    $tmpfile = New-TemporaryFile
    try {
        $broot = $env:BROOT
        if (-not $broot) {
             $broot = 'broot'
        }
        & $broot --outcmd $tmpfile $args
        if ($LASTEXITCODE -ne 0) {
            Write-Error "$broot exited with code $LASTEXITCODE"
            return
        }
        $cmd = Get-Content $tmpfile
        if ($cmd) {
            Invoke-Expression $cmd
        }
    } finally {
        Remove-Item -force $tmpfile
    }
}

# Update scoop and wsl.
function upgrade {
    wsl --update
    scoop update

    if (scoop status | Select-String -Pattern "pwsh") {
        Write-Host "Close pwsh and update scoop apps? (y/N)"
        if ([console]::ReadKey().Key -eq "Y") {
            start powershell {
                scoop update *
                Write-Host Done.
                Read-Host
            }
            Stop-Process -Name "pwsh"
        }
    } else {
        scoop update *
    }
}

# Remove all in scoop that is not needed anymore.
function cleansys {
    scoop cleanup *
    scoop cache rm *
}

# Aliases
New-Alias -Name ll -Value Get-ChildItem

# Env-vars
$env:EDITOR = "hx"
$env:SHELL  = "pwsh"
$env:POWERSHELL_TELEMETRY_OPTOUT = 1
$env:POWERSHELL_UPDATECHECK      = "Off"

$env:DOCKER_HOST = "tcp://127.0.0.1:2375"
