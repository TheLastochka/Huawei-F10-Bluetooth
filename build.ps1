if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    Exit
}

$PCManagerDir = "C:\Program Files\Huawei\PCManager"

ps2exe -inputFile .\bth.ps1 -outputFile PCManager.exe -iconFile .\bluetooth-white.ico

Write-Host ""
Write-Host "Renaming original PCManager.exe to PCManager.exe.bak"
if (Test-Path $PCManagerDir\PCManager.exe.bak) {
    Write-Host "Original PCManager.exe.bak already renamed"
}
else {
    Rename-Item -Path $PCManagerDir\PCManager.exe -NewName PCManager.exe.bak
}

Write-Host ""
Write-Host "Copying new PCManager.exe to $PCManagerDir"
Copy-Item -Path .\PCManager.exe -Destination $PCManagerDir -Force