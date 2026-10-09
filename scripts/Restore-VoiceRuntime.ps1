[CmdletBinding()]
param(
    [string]$PartsDirectory = $PSScriptRoot,
    [string]$OutputDirectory = $PSScriptRoot
)
$ErrorActionPreference = 'Stop'
$partsRoot = (Resolve-Path -LiteralPath $PartsDirectory).Path
$manifestPath = Join-Path $partsRoot 'voice-runtime-manifest.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($manifest.schemaVersion -ne 1 -or $manifest.parts.Count -lt 1) { throw 'Unsupported or empty manifest.' }
if ($manifest.outputName -ne 'Fairy-Voice-Runtime-Windows-x64.zip') { throw 'Unexpected ZIP output name.' }
if ($manifest.sha256 -notmatch '^[a-fA-F0-9]{64}$') { throw 'Invalid output SHA256.' }
if (-not (Test-Path -LiteralPath $OutputDirectory)) { New-Item -ItemType Directory -Path $OutputDirectory | Out-Null }
$outputRoot = (Resolve-Path -LiteralPath $OutputDirectory).Path
$target = Join-Path $outputRoot $manifest.outputName
$partial = $target + '.partial'
if ((Test-Path -LiteralPath $target) -or (Test-Path -LiteralPath $partial)) {
    throw "Output already exists; choose another -OutputDirectory. No files were overwritten: $target"
}
$partPaths = @()
$sum = [long]0
$index = 0
foreach ($part in $manifest.parts) {
    $index++
    $expected = '{0}.{1:D3}' -f $manifest.outputName, $index
    if ($part.name -ne $expected -or $part.sha256 -notmatch '^[a-fA-F0-9]{64}$' -or [long]$part.bytes -le 0) {
        throw 'Invalid part metadata or order.'
    }
    $path = Join-Path $partsRoot $part.name
    $file = Get-Item -LiteralPath $path
    if ($file.PSIsContainer -or $file.Length -ne [long]$part.bytes) { throw "Wrong part size: $path" }
    Write-Host "Checking SHA256: $($part.name)"
    $hash = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
    if ($hash -ne $part.sha256) { throw "Part SHA256 mismatch. Download again: $path" }
    $partPaths += $path
    $sum += $file.Length
}
if ($sum -ne [long]$manifest.bytes) { throw 'Total part size does not match ZIP size.' }
$writer = $null
try {
    $writer = [System.IO.File]::Open($partial, [System.IO.FileMode]::CreateNew, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    foreach ($path in $partPaths) {
        Write-Host "Merging: $([System.IO.Path]::GetFileName($path))"
        $reader = [System.IO.File]::OpenRead($path)
        try { $reader.CopyTo($writer, 8388608) } finally { $reader.Dispose() }
    }
    $writer.Dispose()
    $writer = $null
    Write-Host 'Checking merged ZIP SHA256...'
    $hash = (Get-FileHash -LiteralPath $partial -Algorithm SHA256).Hash
    if ($hash -ne $manifest.sha256) { throw 'Merged ZIP SHA256 mismatch. Partial file retained for inspection.' }
    [System.IO.File]::Move($partial, $target)
    Write-Host "Success: $target"
    Write-Host 'Extract the ZIP to your chosen directory. Keep the voice-runtime folder structure.'
} finally {
    if ($null -ne $writer) { $writer.Dispose() }
}
