. "$PSScriptRoot\New-Tuple.ps1"

$ErrorActionPreference = "Stop"

function FindLowAndHighPoints(
  [string]$exchange,
  [string]$company) 
{
  if (-not $exchange) { throw "-exchange must be provided"; }
  if (-not $company) { throw "-company must be provided"; }

  $rows = getThreeMonthsData -exchange $exchange -company $company
  $data = $rows | ForEach-Object { New-Tuple("open", [convert]::ToDecimal($_.Open), "close", [convert]::ToDecimal($_.Close)) }
  for ($i = 0; $i -lt $data.Length; $i++) {
    if ($i -lt 3) { continue }
    $avg3 = ($data[$i - 3].open + $data[$i - 3].close) / 2
    $trend3 = $data[$i - 3].open -lt $data[$i - 3].close
    $avg2 = ($data[$i - 2].open + $data[$i - 2].close) / 2
    $trend2 = $data[$i - 2].open -lt $data[$i - 2].close    
    $avg1 = ($data[$i - 1].open + $data[$i - 1].close) / 2
    $trend1 = $data[$i - 1].open -lt $data[$i - 1].close
    $avg0 = ($data[$i - 0].open + $data[$i - 0].close) / 2
    $trend0 = $data[$i - 0].open -lt $data[$i - 0].close

    # it's a low point if
    #    3 days ago open/close trends down
    #    3 days ago open/close average is > 2 days ago
    #    2 days ago open/close trends down
    #    2 days ago open/close average is > 1 day ago
    #    1 day ago open/close trends down
    #    1 day ago open/close average is > today
    #    today open/close trends up
    if ((-not $trend3) -and ($avg3 -gt $avg2) -and
        (-not $trend2) -and ($avg2 -gt $avg1) -and
        (-not $trend1) -and ($avg1 -gt $avg0) -and
        ($trend0)) {
      "low point " + $rows[$i].Date + " at " + $avg0
    }

    # it's a high point if
    #    3 days ago open/close trends up
    #    3 days ago open/close average is < 2 days ago
    #    2 days ago open/close trends up
    #    2 days ago open/close average is < 1 day ago
    #    1 day ago open/close trends up
    #    1 day ago open/close average is < today
    #    today open/close trends down
    if (($trend3) -and ($avg3 -lt $avg2) -and
        ($trend2) -and ($avg2 -lt $avg1) -and
        ($trend1) -and ($avg1 -lt $avg0) -and
        (-not $trend0)) {
      "high point " + $rows[$i].Date + " at " + $avg0
    }
  }
}
