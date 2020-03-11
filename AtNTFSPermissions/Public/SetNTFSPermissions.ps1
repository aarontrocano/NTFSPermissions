<#

#>
$DfsRootToPrune = '\\',''
$ReplaceChar01 = '\','__'
$regexPattern01 = @($DfsRootToPrune | ForEach-Object {[regex]::Escape($_)})
$regexPattern02 = @($ReplaceChar01 | ForEach-Object {[regex]::Escape($_)})

$Import = Get-Content -Path ([Environment]::GetFolderPath("Desktop")+'\dirs.txt')
$What = @("/S","EXAMPLE\Contoso_Data_RW:RWXD")
<#$Options = @("")#>
$LogPrefix = ([Environment]::GetFolderPath("Desktop") + '\fileacl__')
foreach ($strDir in $Import) {
    [string]$Source = [string]$($strDir)
    [string]$LogSuffix = [string]$($strDir) -replace $regexPattern01[0],$regexPattern01[1] -replace $regexPattern02[0],$regexPattern02[1]
    [string]$LogName = $LogPrefix + $LogSuffix + '.txt'
    $cmdArgs = @("$Source",$What)
    Write-Host ('Working on | ' + $Source + ' | ' + (Get-Date).toString() )
    #C:\utilities\fileacl.exe @cmdArgs | Out-File -FilePath $LogName
    #$cmdArgs | Out-String
    #Write-Host ('Done! with | ' + $Source + ' | ' + (Get-Date).toString() )

}
Write-Verbose -Message 'Done!' -Verbose