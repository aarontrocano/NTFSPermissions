<#

#>
<#--Input--#>
$runImport = {
    $SPOReport = Import-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\SortedAMTtoAMYmappingforSPOforIGOR.csv')
    $ADS_AMT_Misfits = Import-Csv -Path ([Environment]::GetFolderPath("Desktop")+'\AmtrustMisfits-6-13-2019.csv')


    $SortedSPOReport = $SPOReport | Sort-Object -Property SamAccountName
    $SortedADS_AMT_Misfits = $ADS_AMT_Misfits | Sort-Object -Property SamAccountName
}
Measure-Command $runImport | Select-Object TotalSeconds


$runStateOneA = {
    [long]$MisfitMatches = 0
    [long]$NonMisfitMatches = 0
    $MisfitsMatched_inStateOneA = $null
    $MisfitsMatched_inStateOneA = @()
    $Step = $Rate = 0; $TotalSteps = $($SPOReport | Measure-Object).Count
    foreach ($SPO in $SortedSPOReport ) {
        $Step++  
        $Rate = [math]::truncate($Step / $TotalSteps * 100)
        Write-Progress -Activity "State One: Matching Misfits in Progress" -Status "$Rate% Complete:" -PercentComplete $Rate
        if ( $SPO.AMTSamAccountName -in $SortedADS_AMT_Misfits.SamAccountName ) {
            $MisfitMatches++
            $MisfitsMatched_inStateOneA += $SPO
        } else {
            $NonMisfitMatches++
        }
    }
}
Measure-Command $runStateOneA | Select-Object TotalSeconds

$MisfitMatches
$($MisfitsMatched_inStateOneA | Measure-Object).Count
$NonMisfitMatches
$($ADS_AMT_Misfits | Measure-Object).Count
$($SPOReport | Measure-Object).Count


$runStateOneB = {
    [long]$MisfitMatches = 0
    [long]$NonMisfitMatches = 0
    $Misfits_forStateTwo = $null
    $Misfits_forStateTwo = @()
    $MisfitsMatched_inStateOneB = $null
    $MisfitsMatched_inStateOneB = @()
    $Step = $Rate = 0; $TotalSteps = $($ADS_AMT_Misfits | Measure-Object).Count
    foreach ($Misfit in $SortedADS_AMT_Misfits ) {
        $Step++  
        $Rate = [math]::truncate($Step / $TotalSteps * 100)
        Write-Progress -Activity "State One: Matching Misfits in Progress" -Status "$Rate% Complete:" -PercentComplete $Rate
        if ( $Misfit.SamAccountName -in $SortedSPOReport.AMTSamAccountName ) {
            $MisfitMatches++
            $MisfitsMatched_inStateOneB += $Misfit
        } else {
            $NonMisfitMatches++
            $Misfits_forStateTwoB += $Misfit
        }
    }
}
Measure-Command $runStateOneB | Select-Object TotalSeconds

$MisfitMatches
$NonMisfitMatches
$($ADS_AMT_Misfits | Measure-Object).Count
$($SPOCensusReport | Measure-Object).Count
$Misfits_forStateTwo | FL

$runStateThreeAB = {
    $MisfitDescrepencyReport = $null
    $MisfitDescrepencyReport = @()
    $SamsHash = $null
    $SamsHash = @()
    foreach ($MisfitB in $MisfitsMatched_inStateOneB ) {
        if (($MisfitB.SamAccountName -in $MisfitsMatched_inStateOneA.AMTSamAccountName ) -and ($MisfitB.SamAccountName -notin $SamsHash )  ) {
            $SamsHash += $MisfitB.SamAccountName
        } else {
            $MisfitDescrepencyReport += $MisfitB
        }
    }
}
Measure-Command $runStateThreeAB | Select-Object TotalSeconds

$($MisfitDescrepencyReport | Measure-Object).Count
