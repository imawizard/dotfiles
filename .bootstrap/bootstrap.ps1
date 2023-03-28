if (!(Get-Command "autohotkey" -ErrorAction SilentlyContinue)) {
    scoop install autohotkey
}

if (!(Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Host "'WinGet' was not found, please install App Installer (MS Store will open)."
    Start-Sleep -s 3
    Start-Process "ms-windows-store://pdp/?ProductId=9NBLGGH4NNS1"
    Read-Host "Press Return to continue"
}

autohotkey bootstrap.ahk
