param(
    [string]$InstallDir,
    [bool]$DeleteSelf = $true
)
Write-Output ("install InstallDir="+$InstallDir+ " DeleteSelf="+$DeleteSelf)
if ($InstallDir -eq "") {
    Write-Error Invalid Arguments
    exit
}
function CheckProcessRunning ([string]$Name) {
    Get-Process $Name -ErrorVariable gpe -ErrorAction SilentlyContinue | Out-Null
    return (([string]$gpe) -eq "")
}
$self = $MyInvocation.MyCommand.Definition
$current = (Split-Path $self)
Write-Output self=$self
Write-Output current=$current
# echo $PSScript
# $MyInvocation.MyCommand.Definition
# if(-not ([Security.Principal.WindowsPrincipal] `
# [Security.Principal.WindowsIdentity]::GetCurrent() `
# ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){
#     Start-Process powershell $MyInvocation.MyCommand.Definition -verb runAs
# }
if ((CheckProcessRunning("ScreenHelper"))) {
    Write-Output please shutdown ScreenHelper
    Wait-Process ScreenHelper
}
Write-Output updating...

# Write-Output ("remove "+(Join-Path $InstallDir "\*"))
# Remove-Item (Join-Path $InstallDir "\*") -Force -Recurse

Write-Output ("copy "+(Join-Path $current "\*")+" -> "+$InstallDir)
Copy-Item -Path (Join-Path $current "\*") -Destination $InstallDir -Force -Recurse

# if ($DeleteSelf) {
#     Write-Output ("remove "+$current)
#     Remove-Item ($current) -Force -Recurse
# }

Start-Process (Join-Path $InstallDir "\ScreenHelper.exe")
Write-Output updated