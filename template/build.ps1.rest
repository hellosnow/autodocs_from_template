$ErrorActionPreference = 'Stop'

$scriptPath = $MyInvocation.MyCommand.Path
$scriptsHome = Split-Path $scriptPath
$restDocsPath = Split-Path $scriptsHome

Push-Location $scriptsHome

$RestSrcPath = Join-Path $restDocsPath "src"
$RestProcessorZip = "RestProcessor.zip"
$RestProcessor = "RestProcessor"
$MappingFilePath = "mapping.json"

# Unzip RestProcessorZip to RestProcessor
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}
if (Test-Path $RestProcessor){
    Remove-Item $RestProcessor -recurse -Force
}
Unzip $scriptsHome\$RestProcessorZip $scriptsHome\$RestProcessor

& $RestProcessor\$RestProcessor\$RestProcessor.exe $RestSrcPath $restDocsPath $restDocsPath\$MappingFilePath
if($LASTEXITCODE -ne 0)
{
    Pop-Location
    exit 1
}

# Clean unzipped folder
Remove-Item $RestProcessor -recurse -Force

Pop-Location
