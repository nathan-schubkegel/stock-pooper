. "$PSScriptRoot$($slash)getCompanies.ps1"
. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"
. "$PSScriptRoot$($slash)findLowAndHighPoints.ps1"
. "$PSScriptRoot$($slash)New-Tuple.ps1"

function makePlotForAllCompanies(
  [switch]$forceDownload,
  [string]$exchange,
  [string]$pngDir
) {
  if (-not $exchange) { throw "-exchange is required."; }

  $companies = getCompanies -forceDownload:$forceDownload -exchange $exchange
  foreach ($company in $companies) {
    $pngPath = $null
    if ($pngDir) {
      $pngPath = "$pngDir$($slash)$company.png"
    }    
    makePlot -exchange $exchange -company $company -forceDownload:$forceDownload -pngPath $pngPath
  }
}
