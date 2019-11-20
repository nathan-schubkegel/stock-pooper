function getThreeMonthsData(
  [switch]$forceDownload,
  [switch]$forceJsonToCsv,
  [string]$exchange,
  [string]$company
) {
  if ($exchange -eq $null) { throw "-exchange is required" }
  if ($company -eq $null) { throw "-company is required" }
  $apiKey = Get-Content -Path "$PSScriptRoot\api_key.txt" -First 1

  $jsonPath = "$PSScriptRoot\data\$exchange\$company\threeMonths.json"
  $jsonAcquired = $false
  if ($forceDownload -or -not (Test-Path -Path $jsonPath -PathType Leaf)) {
    $jsonAcquired = $true
    Write-Host "Downloading data for company $company from exchange $exchange"
    $unused = [system.io.directory]::CreateDirectory("$PSScriptRoot\data\$exchange\$company")
    $from = (Get-Date).Subtract([System.TimeSpan]::FromDays(90)).ToString("yyyy-MM-dd")
    $to = (Get-Date).ToString("yyyy-MM-dd")
    $url = "https://www.quandl.com/api/v3/datasets/$exchange/$company.json?start_date=$from&end_date=$to&api_key=$apiKey"

    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12;
    $wc = New-Object System.Net.WebClient
    $unused = $wc.DownloadFile($url, $jsonPath)
  }

  $csvPath = "$PSScriptRoot\data\$exchange\$company\threeMonths.csv"
  if ($jsonAcquired -or $forceJsonToCsv -or -not (Test-Path -Path $csvPath -PathType Leaf)) {

    function ArrayToCsv($fields) {
      $result = ""
      foreach ($field in $fields) {
        if ($result -ne "") {
          $result += ","
        }
        if ($field -ne $null) {
          $result += '"' + $field.ToString().Replace('"', '""') + '"'
        }
        else {
          $result += '""'
        }
      }
      return $result
    }

    $json = Get-Content -Path $jsonPath | ConvertFrom-Json
    $lines = @()
    $lines += ArrayToCsv($json.dataset.column_names) 
    foreach ($d in $json.dataset.data) {
      $lines += ArrayToCsv($d)
    }
    $lines | Set-Content -Path $csvPath
  }

  $csv = Import-Csv -Path $csvPath
  $csv
}