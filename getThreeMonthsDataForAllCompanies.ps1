. "$PSScriptRoot$($slash)getCompanies.ps1"
. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"
. "$PSScriptRoot$($slash)New-Tuple.ps1"

function getThreeMonthsDataForAllCompanies(
  [switch]$forceDownload,
  [string]$exchange
) {
  $companies = getCompanies -forceDownload:$forceDownload -exchange $exchange
  foreach ($company in $companies) {
    $data = getThreeMonthsData -forceDownload:$forceDownload -exchange $exchange -company $company
    New-Tuple("company", $company, "data", $data)
  }
}