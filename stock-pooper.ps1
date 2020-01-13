param (
  [string]$op = $(throw "-op is required"),
  [string]$exchange,
  [string]$company,
  [string]$pngDir,
  [string]$pngPath,
  [switch]$forceDownload,
  [switch]$forceJsonToCsv
)

# stuff used by every included file
$ErrorActionPreference = "Stop"
$slash = [IO.Path]::DirectorySeparatorChar
$apiKeyPath = "$PSScriptRoot{0}api_key.txt" -f $slash
$apiKey = Get-Content -Path $apiKeyPath -First 1

. "$PSScriptRoot$($slash)getCompanies.ps1"
. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"
. "$PSScriptRoot$($slash)getThreeMonthsDataForAllCompanies.ps1"
. "$PSScriptRoot$($slash)findLowAndHighPoints.ps1"
. "$PSScriptRoot$($slash)findLowAndHighPointsForAllCompanies.ps1"
. "$PSScriptRoot$($slash)makePlot.ps1"
. "$PSScriptRoot$($slash)makePlotForAllCompanies.ps1"

if ($op -eq 'getCompanies') {
  getCompanies -exchange $exchange -forceDownload:$forceDownload
}
elseif ($op -eq 'getThreeMonthsData') {
  getThreeMonthsData -exchange $exchange -company $company -forceDownload:$forceDownload -forceJsonToCsv:$forceJsonToCsv
}
elseif ($op -eq 'getThreeMonthsDataForAllCompanies') {
  getThreeMonthsDataForAllCompanies -exchange $exchange -forceDownload:$forceDownload
}
elseif ($op -eq 'findLowAndHighPoints') {
  findLowAndHighPoints -exchange $exchange -company $company
}
elseif ($op -eq 'findLowAndHighPointsForAllCompanies') {
  findLowAndHighPointsForAllCompanies -exchange $exchange -forceDownload:$forceDownload
}
elseif ($op -eq 'makePlot') {
  makePlot -exchange $exchange -company $company -forceDownload:$forceDownload -pngPath $pngPath
}
elseif ($op -eq 'makePlotForAllCompanies') {
  makePlotForAllCompanies -exchange $exchange -forceDownload:$forceDownload -pngDir $pngDir
}
else {
  throw "narp, unrecognized op yo"
}
