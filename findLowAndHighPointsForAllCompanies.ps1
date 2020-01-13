. "$PSScriptRoot$($slash)getCompanies.ps1"
. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"
. "$PSScriptRoot$($slash)findLowAndHighPoints.ps1"
. "$PSScriptRoot$($slash)New-Tuple.ps1"

function findLowAndHighPointsForAllCompanies(
  [switch]$forceDownload,
  [string]$exchange
) {
  if (-not $exchange) { throw "-exchange is required."; }

  $outFilePath = "$PSScriptRoot\data\low_and_high_points.txt"
  "whut" | Add-Content -Path $outFilePath
  Clear-Content -Force -Path $outFilePath

  $companies = getCompanies -forceDownload:$forceDownload -exchange $exchange
  foreach ($company in $companies) {
    $unused = getThreeMonthsData -forceDownload:$forceDownload -exchange $exchange -company $company
    $results = findLowAndHighPoints -exchange $exchange -company $company
    New-Tuple("company", $company, "results", $results)
    if ($results) {
      $company | Add-Content -Path $outFilePath
      $results | Add-Content -Path $outFilePath
      "" | Add-Content -Path $outFIlePath
    }
    
  }
}
