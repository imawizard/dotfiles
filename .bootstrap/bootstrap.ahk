DllCall("AllocConsole")

; Create HOME env-variable.
if !EnvGet("HOME") {
    RegWrite(EnvGet("USERPROFILE"), "REG_SZ", "HKCU\Environment", "HOME")
}

; Install keyboard layout.
if !FileExist(EnvGet("USERPROFILE") "\.bootstrap\Amalgamation.keylayout") {
    RunWait("git clone https://github.com/imawizard/Amalgamation.keylayout `"" EnvGet("USERPROFILE") "\.bootstrap\Amalgamation.keylayout`"")
    RunWait("git clone https://github.com/imawizard/MiguruWM               `"" EnvGet("USERPROFILE") "\.bootstrap\MiguruWM`"")
    for script in ["amalgamation.ahk", "mwm.ahk"] {
        FileCreateShortcut(
            EnvGet("USERPROFILE") "\.bootstrap\Amalgamation.keylayout\windows\" script,
            EnvGet("APPDATA") "\Microsoft\Windows\Start Menu\Programs\Startup\" script ".lnk",
            EnvGet("USERPROFILE") "\.bootstrap\Amalgamation.keylayout\windows",
        )
    }
}

; Flip all mouses' wheels.
loop reg "HKLM\SYSTEM\CurrentControlSet\Enum\HID", "KVR" {
    if A_LoopRegName == "FlipFlopWheel" {
        try RegWrite(1)
    }
}

 try RegWrite(1,   "REG_DWORD", "HKLM\System\CurrentControlSet\Control\FileSystem",                          "LongPathsEnabled")              ; Enable long paths
;try RegWrite(1,   "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System",            "DisableLockWorkstation")        ; Disable locking as a whole with its Win+L hotkey

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
    "extras",
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
    "autohotkey",
    "curl",
    "fzf",
    "helix",
    "less",
    "neovim-nightly",
    "opera",
    "powertoys",
    "pwsh",
    "ripgrep",
    "sed",
    "uutils-coreutils",
    "which",
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
    ;"kind",
    ;"lazydocker",
    ;"minikube",
    ;"rancher-desktop",
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
    ;"draw.io",
    ;"freac",
    ;"miktex",
    ;"paint.net",
    ;"spytify",
    ;"vlc",
    ;"yed",
    ;"youtube-dl-gui",
    "FiraCode-NF",
    "FiraCode-NF-Mono",

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
    ;"Neovim",                                   "-s winget Neovim.Neovim.Nightly",
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
    RunWait("winget install "
        "--accept-source-agreements "
        "--accept-package-agreements "
        pkg)
}

; Setup rust toolchain.
;RunWait("rustup toolchain install nightly")
;RunWait("rustup default nightly")

; Install neovim plugins.
;RunWait("git clone https://github.com/wbthomason/packer.nvim `"" EnvGet("LOCALAPPDATA") "\nvim-data\site\pack\packer\start\packer.nvim`"")
;RunWait("git clone https://github.com/rktjmp/hotpot.nvim  `""    EnvGet("LOCALAPPDATA") "\nvim-data\site\pack\packer\start\hotpot.nvim`"")
;RunWait("nvim --headless -c `"autocmd User PackerComplete qa`" +PackerSync")

RunWait("cmd /c pause")
