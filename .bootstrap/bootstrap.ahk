DllCall("AllocConsole")

; Create HOME env-variable.
if !EnvGet("HOME") {
    RegWrite(EnvGet("USERPROFILE"), "REG_SZ", "HKCU\Environment", "HOME")
}

; Create shortcut if no ~\Desktop.
if !FileExist(EnvGet("USERPROFILE") "\Desktop") {
    if A_IsAdmin {
        ; /j doesn't work for network drives, /d requires admin privileges
        RunWait("cmd /c mklink /d `"" EnvGet("USERPROFILE") "\Desktop`" `"" A_Desktop "`"")
    }
}

; Install keyboard layout, window manager and more.
CloneBootstrapRepo("imawizard/Amalgamation.keylayout")
CloneBootstrapRepo("imawizard/MiguruWM")
CloneBootstrapRepo("imawizard/chrome-extensions")

; Put keyboard layout and window manager on desktop and in autostart.
for script in ["amalgamation.ahk", "mwm.ahk"] {
    dir := EnvGet("USERPROFILE") "\.bootstrap\Amalgamation.keylayout\windows"
    FileCreateShortcut(dir "\" script, A_Startup "\" script ".lnk", dir)
    FileCreateShortcut(dir "\" script, A_Desktop "\" script ".lnk", dir)
}

; Flip all mouses' wheels.
loop reg "HKLM\SYSTEM\CurrentControlSet\Enum\HID", "KVR" {
    if A_LoopRegName == "FlipFlopWheel" {
        try RegWrite(1)
    }
}

 try RegWrite(1,   "REG_DWORD", "HKLM\System\CurrentControlSet\Control\FileSystem",                          "LongPathsEnabled")              ; Enable long paths
;try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System",            "DisableLockWorkstation")        ; Disable locking as a whole with its Win+L hotkey
 try RegWrite(0,   "REG_DWORD", "HKCU\Control Panel\Keyboard",                                               "PrintScreenKeyForSnippingEnabled")

; Adjust taskbar.
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\DWM",                                       "EnableAeroPeek")                ; Disable Aero Peek
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "DisablePreviewDesktop")         ; Disable previewing the desktop
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "TaskbarSmallIcons")             ; Enable small buttons
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "TaskbarSizeMove")               ; Fixate it
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "TaskbarGlomLevel")              ; Combine buttons: 0 always, 1 if full, 2 never
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer",                   "EnableAutoTray")                ; Show all tray icons
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "DontUsePowerShellOnWinX")       ; Replace Cmd with Powershell when right-clicking the start-menu
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Search",                     "SearchboxTaskbarMode")          ; Show search-butten
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "ShowTaskViewButton")            ; Hide taskview-button
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People",   "PeopleBand")                    ; Hide contacts-button
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "TaskbarAnimations")             ; Show animations
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications", "NoTileApplicationNotification") ; Disable tiles

; Adjust explorer.
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "LaunchTo")                      ; Set the default location to 'This PC'
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "HideFileExt")                   ; Show all file extensios
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "HideDrivesWithNoMedia")         ; Show empty drives
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "Hidden")                        ; Show all files
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "PersistBrowsers")               ; Restore windows on next boot
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "NavPaneShowAllFolders")         ; Show all folders in navigation
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "NavPaneExpandToCurrentFolder")  ; Scroll to actual folder in navigation
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon",            "MinimizedStateTabletModeOff")   ; Hide ribbon
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer",                   "ShowRecent")                    ; Don't show least recently used files in quickbar
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer",                   "ShowFrequent")                  ; Don't show often used folders in quickbar
 try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers",  "DisableAutoplay")               ; Disable autoplay
 try RegWrite(255, "REG_DWORD", "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer",          "NoDriveTypeAutoRun")            ; ^
 try RegWrite(1,   "REG_DWORD", "HKLM\Software\Policies\Microsoft\Windows\Explorer",                         "NoUseStoreOpenWith")            ; Disable searching in store for unknown file extensions
 try RegWrite(1,   "REG_DWORD", "HKLM\Software\Policies\Microsoft\Windows\Explorer",                         "NoNewAppAlert")                 ; Disable alert for unknown file extensions
 try RegWrite(2,   "REG_DWORD", "HKCU\Control Panel\Desktop",                                                "MouseWheelRouting")             ; Scroll hovered window instead of active one.

; Adjust privacy settings.
 try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo",            "Enabled")                       ; Disallow apps to use the ad-id
;try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "Start_TrackProgs")              ; Allow tracking starting of apps
;try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced",          "Start_TrackDocs")               ; Show last opened elements in start-menu
;try RegWrite(1,   "REG_DWORD", "HKCU\Control Panel\International\User Profile",                             "HttpAcceptLanguageOptOut")      ; Disallow websites to access the languages
;try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Search",                     "BingSearchEnabled")             ; Disable Bing-Search
;try RegWrite(0,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Search",                     "CortanaConsent")                ; ^
;try RegWrite(0,   "REG_DWORD", "HKLM\Software\Policies\Microsoft\Windows\Windows Search",                   "AllowCortana")                  ; Disallow Cortana
;try RegWrite(0,   "REG_DWORD", "HKLM\Software\Policies\Microsoft\Windows\Windows Search",                   "AllowSearchToUseLocation")      ; ^
;try RegWrite(1,   "REG_DWORD", "HKLM\Software\Policies\Microsoft\Windows\Windows Search",                   "DisableWebSearch")              ; ^

; Install software via Scoop.
for bucket in [
    "versions",
    "nerd-fonts",
    "java",
    ;"games",
    ;"nonportable",
    ;"scoop-clojure https://github.com/littleli/scoop-clojure",
    ;"emulators https://github.com/hermanjustnu/scoop-emulators.git",
    ;"emulators https://github.com/borger/scoop-emulators.git",
] {
    RunWait("scoop.cmd "
        "bucket add "
        bucket)
}
for pkg in [
    ; Essentials
    ;"git-with-openssh",
    ;"openssh",
    "curl",
    "fzf",
    "helix",
    "less",
    "neovim",
    "opera",
    "powertoys",
    "pwsh",
    "ripgrep",
    "sed",
    "uutils-coreutils",
    "wezterm",
    "which",
    "win32yank",
    "windows-terminal",
    "zoxide",

    ; CLI tools
    ;"bat",
    ;"hyperfine",
    ;"netcat",
    ;"pshazz",
    ;"psutils",
    ;"sqlite",
    ;"telnet",
    ;"wget",
    ;"sudo",
    "broot",
    "cloc",
    "jq",
    "lazygit",

    ; GUI tools
    ;"cpu-z",
    ;"etcher",
    ;"gitextensions",
    ;"gpu-z",
    ;"heidisql",
    ;"hxd",
    ;"keepass",
    ;"rufus",
    ;"sqlitebrowser",
    ;"ssd-z",
    ;"sysinternals",
    ;"teamviewer",
    ;"wincdemu",
    "quicklook",
    "systeminformer-nightly",
    "winmerge",
    "zeal",

    ; Coding
    ;"clojure",
    ;"composer",
    ;"dart",
    ;"deno",
    ;"flat-assembler",
    ;"flutter",
    ;"gcc",
    ;"go",
    ;"graalvm-jdk17",
    ;"janet",
    ;"leiningen",
    ;"llvm",
    ;"lua",
    ;"luarocks",
    ;"make",
    ;"maven",
    ;"nodejs",
    ;"python",
    ;"qemu",
    ;"ruby",
    ;"rustup",
    ;"temurin8-jdk",
    ;"universal-ctags",
    "perl",

    ; DevOps
    ;"aws",
    ;"k9s",
    ;"kind",
    ;"kubectl",
    ;"lazydocker",
    ;"minikube",
    ;"rancher-desktop",
    ;"stern",
    ;"terraform",

    ; Reversing
    ;"dnspy",
    ;"dotpeek",
    ;"ida-free",
    ;"ilspy",
    ;"jd-gui",
    ;"resource-hacker",
    ;"x64dbg",

    ; Multimedia
    ;"anki",
    ;"audacity",
    ;"freac",
    ;"miktex",
    ;"paint.net",
    ;"spytify",
    ;"vlc",
    ;"yed",
    ;"youtube-dl-gui",
    "draw.io",
    "ffmpeg",
    "FiraCode-NF",
    "FiraCode-NF-Mono",
    "gifski",
    "screentogif",

    ; Gaming
    ;"cemu",
    ;"citra-nightly",
    ;"discord",
    ;"dolphin-beta",
    ;"dosbox",
    ;"project64",
    ;"steam",
    ;"teamspeak3",
    ;"yuzu-nightly",

    ; Games
    ;"Blobby Volley",
    ;"Cannon Hill v.1.3",
    ;"Icy Tower",
    ;"Island Wars",
    ;"Little Fighter 2",
    ;"Zataka",
] {
    RunWait("scoop.cmd install "
        pkg)
}

; Install software via WinGet.
for name, pkg in Map(
    ;"AutoHotkey",                               "-s winget AutoHotkey.AutoHotkey",
    "DevToys",                                   "-s msstore 9PGCV4V3BK4W",
    "Diagnostic Data Viewer",                    "-s msstore 9N8WTRRSQ8F7",
    ;"Docker Desktop",                           "-s winget Docker.DockerDesktop",
    ;"Git Extensions",                           "-s winget GitExtensionsTeam.GitExtensions",
    ;"IDA Free",                                 "-s winget Hex-Rays.IDA.Free",
    ;"ILSpy",                                    "-s winget icsharpcode.ILSpy",
    ;"ILSpy",                                    "-s msstore 9MXFBKFVSQ13",
    ;"Microsoft PowerToys",                      "-s winget Microsoft.PowerToys",  ; Requires UAC
    ;"Microsoft PowerToys",                      "-s msstore XP89DCGQ3K6VLD",
    "Microsoft To Do: Lists, Tasks & Reminders", "-s msstore 9NBLGGH5R558",
    ;"Microsoft.PowerShell",                     "-s winget Microsoft.PowerShell", ; Requires UAC
    ;"Microsoft.PowerShell",                     "-s msstore 9MZ1SNWT0N5D",
    ;"Microsoft.WindowsTerminal",                "-s winget Microsoft.WindowsTerminal",
    ;"Microsoft.WindowsTerminal",                "-s msstore 9N0DX20HK701",
    ;"Neovim",                                   "-s winget Neovim.Neovim",
    ;"Opera",                                    "-s winget Opera.Opera",
    ;"Oracle Linux 9",                           "-s msstore 9MXQ65HLMC27",
    ;"QuickLook",                                "-s winget QL-Win.QuickLook",
    ;"QuickLook",                                "-s msstore 9NV4BS3L1H4S",
    ;"Rustup",                                   "-s winget Rustlang.Rustup",
    "Snipping Tool",                             "-s msstore 9MZ95KL8MR0L",
    "Ubuntu 22.04",                              "-s msstore 9PN20MSR04DW",
    "WinDbg Preview",                            "-s msstore 9PGJGD53TN86",
    ;"Windows-Subsystem for Linux",              "-s msstore 9P9TQF7MRM4R",
    ;"WinMerge",                                 "-s winget WinMerge.WinMerge",
    "Woop!",                                     "-s msstore 9PM8GJ333468",
    ;"Xbox Gamebar",                             "-s msstore 9NZKPSTSNW4P",
    ;"Zeal",                                     "-s winget OlegShparber.Zeal",
) {
    if !InStr(pkg, "-s msstore") || HasMicrosoftStore() {
        RunWait("winget install "
            "--accept-source-agreements "
            "--accept-package-agreements "
            pkg)
    }
}

path := Exec("scoop.cmd prefix opera")[2]
if FileExist(path) {
    ; FIXME: Apparently must be written to HKLM to be listed under Settings > Standard-Apps > Webbrowser.
    try RegWrite("Software\Clients\StartMenuInternet\ScoopedOpera\Capabilities", "REG_SZ", "HKCU\SOFTWARE\RegisteredApplications", "ScoopedOpera")
    try RegWrite("Opera",                                                        "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera")
    try RegWrite("Opera",                                                        "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities", "ApplicationName")
    try RegWrite("Opera (Installed with Scoop)",                                 "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities", "ApplicationDescription")
    try RegWrite(path "\launcher.exe,0",                                         "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities", "ApplicationIcon")
    try RegWrite(path "\launcher.exe,0",                                         "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\DefaultIcon")
    try RegWrite("ScoopedOpera",                                                 "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities\StartMenu", "StartMenuInternet")
    try RegWrite("ScoopedOpera",                                                 "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities\URLAssociations", "http")
    try RegWrite("ScoopedOpera",                                                 "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\Capabilities\URLAssociations", "https")
    try RegWrite("`"" path "\launcher.exe`"",                                    "REG_SZ", "HKCU\SOFTWARE\Clients\StartMenuInternet\ScoopedOpera\shell\open\command")
}

; Setup rust toolchain.
if IsExecutable("rustup") {
    RunWait("rustup toolchain install nightly")
    RunWait("rustup default nightly")
}

; Install neovim plugins.
if IsExecutable("nvim -c q") {
    CloneNeovimRepo("wbthomason/packer.nvim")
    CloneNeovimRepo("rktjmp/hotpot.nvim")
    if IsDeveloperMode() {
        RunWait("nvim --headless -c `"autocmd User PackerComplete qa`" +PackerSync")
    }
}

RunWait("cmd /c pause")

CloneBootstrapRepo(id) {
    CloneRepo(id, EnvGet("USERPROFILE") "\.bootstrap")
}

CloneNeovimRepo(id) {
    CloneRepo(id, EnvGet("LOCALAPPDATA") "\nvim-data\site\pack\packer\start")
}

CloneRepo(id, dir) {
    name := StrSplit(id, "/")[2]
    dest := dir "\" name

    if !FileExist(dest) {
        RunWait("git clone https://github.com/" id " `"" dir "`"")
    } else {
        RunWait("git pull", dest)
    }
}

IsExecutable(cmd) {
    try {
        RunWait(cmd)
        return true
    } catch {
        return false
    }
}

HasMicrosoftStore() {
    try {
        value := RegRead("HKLM\SOFTWARE\Policies\Microsoft\WindowsStore", "RemoveWindowsStore")
        return value == 0
    }
    return true
}

IsDeveloperMode() {
    try {
        value := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock", "AllowDevelopmentWithoutDevLicense")
        return value == 1
    }
    return false
}

Exec(cmd, stdin := "") {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(cmd)
    if stdin !== "" {
        exec.StdIn.WriteLine(stdin)
    }
    while exec.Status == 0 {
        Sleep(20)
    }
    return [exec.ExitCode(), SubStr(exec.StdOut.ReadAll(), 1, -2)]
}
