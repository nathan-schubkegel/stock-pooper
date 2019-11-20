param (
  [string]$op = $(throw "-op is required"),
  [string]$exchange,
  [string]$company,
  [switch]$forceDownload,
  [switch]$forceJsonToCsv
)

$ErrorActionPreference = "Stop"
#$apiKey = Get-Content -Path "$PSScriptRoot\api_key.txt" -First 1

. "$PSScriptRoot\getCompanies.ps1"
. "$PSScriptRoot\getThreeMonthsData.ps1"
. "$PSScriptRoot\getThreeMonthsDataForAllCompanies.ps1"

if ($op -eq 'getCompanies') {
  getCompanies -exchange $exchange -forceDownload:$forceDownload
}
elseif ($op -eq 'getThreeMonthsData') {
  getThreeMonthsData -exchange $exchange -company $company -forceDownload:$forceDownload -forceJsonToCsv:$forceJsonToCsv
}
elseif ($op -eq 'getThreeMonthsDataForAllCompanies') {
  getThreeMonthsDataForAllCompanies -exchange $exchange -forceDownload:$forceDownload
}