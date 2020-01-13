. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"

function makePlot(
  [string]$exchange,
  [string]$company,
  [switch]$forceDownload,
  [string]$pngPath
) {
  if (-not $exchange) { throw "-exchange is required"; }
  if (-not $company) { throw "-company is required"; }

  if (-not $pngPath) {
    $pngPath = "$PSScriptRoot$($slash)data$($slash)$exchange$($slash)$company$($slash)threeMonths.png"
  }

  $csvRows = getThreeMonthsData -exchange $exchange -company $company -forceDownload:$forceDownload
  if (-not $csvRows) {
    return
  }
  [array]::Reverse($csvRows)

  # ripped off from https://github.com/horker/oxyplotcli2/blob/master/examples/Plot-CandleStickSeries.ps1
  $orcl = $csvRows | oxy.candle -XName Date -OpenName Open -HighName High -LowName Low -CloseName Close -YAxisKey $company
  $xAxis = oxy.axis.dateTime -StringFormat "yyyy/MM/dd" -IntervalType Weeks -Title "Date"
  $orclAxis = oxy.axis.linear -Key $company -Position Left -Title "Price ($company)" -EndPosition .65
  $orclText = oxy.ann.text -text $company -TextPosition "2017/11/20", 50.2 -Background white -YAxisKey $company

  oxy.model -SeriesInfo $orcl `
    -Axis $xAxis, $orclAxis `
    -Annotation $orclText `
    -Title "Stock Prices: $company" `
    -OutFile $pngPath `
    -OutWidth 800 `
    -OutHeight 800

  $pngPath
}
