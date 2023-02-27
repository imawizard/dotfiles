Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineKeyHandler -Chord "Ctrl+RightArrow" -Function ForwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+LeftArrow"  -Function BackwardWord
Set-PSReadLineKeyHandler -Chord "Ctrl+Backspace"  -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord "Ctrl+Delete"     -Function DeleteWord
Set-PSReadLineKeyHandler -Chord "Ctrl+-"          -Function Undo
New-Alias -Name ll -Value Get-ChildItem

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { "prompt" } else { "pwd" }
    (zoxide init --hook $hook powershell | Out-String)
})

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
