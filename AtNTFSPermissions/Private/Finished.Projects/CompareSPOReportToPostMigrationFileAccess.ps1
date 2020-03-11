<#
CompareSPOReportToPostMigrationFileAccess.ps1
#>
$SPOCensusReport = Import-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\SortedSPOCensusMatches.csv')
$AmyntaPostMigrationFileAccessAccounts = Import-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\AmyntaPostMigrationFileAccessEDWAccounts.csv')


$runStateOne = {
    $SPOCRPT_forStateTwo = $null
    $SPOCRPT_forStateTwo = @()
    $SPOCAccessMatches_forStateOne = $null
    $SPOCAccessMatches_forStateOne = @()
    $Step = $Rate = 0; $TotalSteps = $($SPOCensusReport | Measure-Object).Count
    foreach ($SPOC_User in $SPOCensusReport ) {
        $Step++  
        $Rate = [math]::truncate($Step / $TotalSteps * 100)
        Write-Progress -Activity "State One: AD Report in Progress" -Status "$Rate% Complete:" -PercentComplete $Rate
        if ($SPOC_User.AMTSamAccountName -in $AmyntaPostMigrationFileAccessAccounts.AMTSamAccountName ) {
            $SPOCAccessMatches_forStateOne += $SPOC_User
        } else {
            $SPOCRPT_forStateTwo += $SPOC_User
        }
    }
    $($SPOCensusReport | Measure-Object ).Count
    $($SPOCRPT_forStateTwo | Measure-Object ).Count
    $($AmyntaPostMigrationFileAccessAccounts | Measure-Object ).Count
    $($SPOCAccessMatches_forStateOne | Measure-Object ).Count
    $SPOCRPT_forStateTwo | Export-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\SortedSPOCensusMatches_FilteredNoPostMigrationFileAccessEDWAccounts.csv') -NoTypeInformation 
}
Measure-Command $runStateOne | Select-Object totalseconds

