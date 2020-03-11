<#

#>
#$DfsRootToPrune = '\\example.com\',''
$DfsRootToPrune = '\\',''
$ReplaceChar01 = '\','__'
#$ReplaceChar02 = ' ','_'
$regexPattern01 = @($DfsRootToPrune | ForEach-Object {[regex]::Escape($_)})
$regexPattern02 = @($ReplaceChar01 | ForEach-Object {[regex]::Escape($_)})



$Import = Import-Csv -Path ([Environment]::GetFolderPath("Desktop") + '\FileAcl - Contoso Data.csv')
$What = @("/NOINHERITED","/LINE","/BATCHREAL",'/QUOTE')
$Options = @("/SUB:7")
$LogPrefix = ([Environment]::GetFolderPath("Desktop") + '\fileacl__')
<# 
    $cmdArgs = @("$Source",$What,$Options)
    USAGE: C:\utilities\fileacl.exe @cmdArgs | Out-File -FilePath $LogName
#>
ForEach ($obj in $Import) {
    [string]$Source = [string]$($obj.path)
    [string]$LogSuffix = [string]$($obj.path) -replace $regexPattern01[0],$regexPattern01[1] -replace $regexPattern02[0],$regexPattern02[1]
    [string]$LogName = $LogPrefix + $LogSuffix + '.txt'
    $cmdArgs = @("$Source",$What,$Options)
    Write-Host ('Working on | ' + $Source + ' | ' + (Get-Date).toString() )
    C:\utilities\fileacl.exe @cmdArgs | Out-File -FilePath $LogName
    #Write-Host "$cmdArgs"
    Write-Host ('Done! with | ' + $Source + ' | ' + (Get-Date).toString() )
    
}
Write-Host ('Done!')