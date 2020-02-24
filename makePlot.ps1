. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"
. "$PSScriptRoot$($slash)New-Tuple.ps1"

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

  # ripped off from https://github.com/horker/oxyplotcli2/blob/master/examples/Plot-CandleStickSeries.ps1
  $orcli = $csvRows | oxy.candle -XName Index -OpenName Open -HighName High -LowName Low -CloseName Close
  $mords = $csvRows | ForEach-Object { 
    New-Tuple("Index", $_.Index, "Value", $_.Open); 
    New-Tuple("Index", "$($_.Index).5", "Value", $_.Close);
  } | oxy.line -XName Index -YName Value -Color red -LineStyle Solid -StrokeThickness 3

  oxy.model -SeriesInfo $orcli, $mords `
    -Title "Stock Prices: $company" `
    -OutFile $pngPath `
    -OutWidth 800 `
    -OutHeight 800

  $pngPath
}
