. "$PSScriptRoot$($slash)getThreeMonthsData.ps1"

function makePlot(
  [string]$exchange,
  [string]$company
) {
  if (-not $exchange) { throw "-exchange is required"; }
  if (-not $company) { throw "-company is required"; }



# Import the required modules
Import-Module –Name "Path\To\OxyPlot.Pdf.dll"
Import-Module –Name "Path\To\OxyPlot.dll"

# define a function 
function PlotLineChart
{
  Param($name = "Test")

  Begin
  {
    # initialise the Model and Series
    $model = New-Object OxyPlot.PlotModel;
    $series = New-Object OxyPlot.Series.LineSeries;
    $model.Series.Add($series);
    $model.Title = $name;

    # get ready to count
    $i = 0;
  }

  Process
  {
    # add a point to series
    $p = New-Object OxyPlot.DataPoint($i++, $_);
    $series.Points.Add($p);
  }

  End
  {
    # initialise an exporter
    $pdfExporter = New-Object OxyPlot.Pdf.PdfExporter;
    $pdfExporter.Width = 297 / 25.4 * 72; # A4
    $pdfExporter.Height = 210 / 25.4 * 72;

    # write the model out to a file
    $model.InvalidatePlot($true);
    $fs = New-Object System.IO.FileStream("$name.pdf", [System.Io.FileMode]::OpenOrCreate);
    $pdfExporter.Export($model, $fs);
    $fs.Close();
  }
}




  $csvRows = getThreeMonthsData -exchange $exchange -company $company
  [array]::Reverse($csvRows)
  $pngPath = "$PSScriptRoot$($slash)data$($slash)$exchange$($slash)$company$($slash)threeMonths.png"

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
}
