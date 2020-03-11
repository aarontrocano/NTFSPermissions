$export = [Environment]::GetFolderPath("Desktop")+'\NAR_ACL.csv'
$RootPath = '\\host01\officeshares01$\USA\West\USA-CA-Narnia-NAR'
$Folder = Get-Item $RootPath
$arrACL = Get-Acl $Folder.FullName | ForEach-Object {$_.Access }
