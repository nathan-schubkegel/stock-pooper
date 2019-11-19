param (
  [boolean]$forceDownload = $false,
  [string]$exchange = $(throw "-exchange is required")
)

$ErrorActionPreference = "Stop"
$apiKey = Get-Content -Path "$PSScriptRoot\api_key.txt" -First 1

$csvPath = "$PSScriptRoot\data\$exchange\companies\$($exchange)_metadata.csv"
if ($forceDownload -or -not (Test-Path -Path $csvPath -PathType Leaf)) {
  Write-Host "Downloading companies for exchange $exchange"
  $unused = [system.io.directory]::CreateDirectory("$PSScriptRoot\data\$exchange\companies")
  $url = "https://www.quandl.com/api/v3/databases/$exchange/metadata?api_key=$apiKey"
  $zipPath = "$PSScriptRoot\data\$exchange\companies.zip"

  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12;
  $wc = New-Object System.Net.WebClient
  $unused = $wc.DownloadFile($url, $zipPath)

  $unused = Expand-Archive -Path $zipPath -DestinationPath "$PSScriptRoot\data\$exchange\companies"
}

$csv = Import-Csv -Path $csvPath
$csv | Select-Object -property code