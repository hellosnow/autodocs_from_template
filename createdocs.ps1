Param(
  [Parameter(Mandatory=$false)][string]$language
)

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function RemoveSuffix
{
    param([string]$file)

    return $file.Substring(0, $file.LastIndexOf('.'))
}

$scriptPath = $MyInvocation.MyCommand.Path
$scriptHome = Split-Path $scriptPath
Push-Location $scriptHome

$templateZip = "template.zip"
$docs = "docs"
Unzip $templateZip $docs
Push-Location $docs
# remove files whose language doesn't match
if (!$language)
{
    $language = "dotnet"
}
$language = "." + $language
get-childItem . | foreach-object {
  if ($_.FullName.EndsWith(".common") -or $_.FullName.EndsWith($language))
  {
    $nameWithoutSUffix = RemoveSuffix $_.FullName
    move-item $_.FullName $nameWithoutSUffix
  }
  else
  {
    remove-item $_.FullName
  }
}
md -Force "api-doc"
New-Item api-doc\.gitkeep -type file
md -Force "api-index"
New-Item api-index\.gitkeep -type file
md -Force "api-ref"
New-Item api-ref\.gitkeep -type file
md -Force "breadcrumb"
New-Item breadcrumb\.gitkeep -type file
md -Force "scripts"
move-item "*.ps1" "scripts\"
move-item "*.js" "scripts\"
move-item "*.zip" "scripts\"

Pop-Location
Pop-Location