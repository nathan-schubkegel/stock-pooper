. "$PSScriptRoot\getCompanies.ps1"
. "$PSScriptRoot\getThreeMonthsData.ps1"

function getThreeMonthsDataForAllCompanies(
  [switch]$forceDownload,
  [string]$exchange
) {
  $companies = getCompanies -forceDownload:$forceDownload -exchange $exchange
  foreach ($company in $companies) {
    $data = getThreeMonthsData -forceDownload:$forceDownload -exchange $exchange -company $company
  }
}