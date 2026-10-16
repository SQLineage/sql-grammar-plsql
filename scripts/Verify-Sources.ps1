$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content -LiteralPath (Join-Path $root 'SOURCE-MANIFEST.json') -Raw | ConvertFrom-Json
foreach ($entry in $manifest.Files) {
    $hash = (Get-FileHash -LiteralPath (Join-Path $root $entry.Path) -Algorithm SHA256).Hash
    if ($hash -ne $entry.Sha256) { throw "Preserved grammar source changed: $($entry.Path)" }
}
Write-Output "Verified $($manifest.Files.Count) preserved grammar source files."
