function getCompanies(
  [switch]$forceDownload,
  [string]$exchange
) {
  if ($exchange -eq $null) { throw "-exchange is required" }

  $csvPath = "$PSScriptRoot{0}data{0}$exchange{0}companies{0}$($exchange)_metadata.csv" -f $slash
  if ($forceDownload -or -not (Test-Path -Path $csvPath -PathType Leaf)) {
    Write-Host "Downloading companies for exchange $exchange"
    $csvDir = [System.IO.Path]::GetDirectoryName($csvPath)
    $unused = [System.IO.Directory]::CreateDirectory($csvDir)
    $url = "https://www.quandl.com/api/v3/databases/$exchange/metadata?api_key=$apiKey"
    $zipPath = "$PSScriptRoot{0}data{0}$exchange{0}companies.zip" -f $slash

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12;
    $wc = New-Object System.Net.WebClient
    $unused = $wc.DownloadFile($url, $zipPath)

    $unused = Expand-Archive -Path $zipPath -DestinationPath $csvDir -Force
  }

  $csv = Import-Csv -Path $csvPath
  $csv | Select-Object -ExpandProperty code
}