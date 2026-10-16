param([string]$FeedPath = (Join-Path $PSScriptRoot '../artifacts/feed'))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$root = Split-Path -Parent $PSScriptRoot
$packages = @(Get-ChildItem -LiteralPath $FeedPath -Filter 'SQLineage.Grammar.PlSql.*.nupkg')
if ($packages.Count -eq 0) { throw 'No grammar packages found for license verification.' }
foreach ($package in $packages) {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($package.FullName)
    try {
        $specEntry = @($zip.Entries | Where-Object { $_.FullName -like '*.nuspec' })
        if ($specEntry.Count -ne 1) { throw 'Expected exactly one package manifest.' }
        $reader = [System.IO.StreamReader]::new($specEntry[0].Open())
        try { [xml]$spec = $reader.ReadToEnd() } finally { $reader.Dispose() }
        if ($spec.package.metadata.license.type -ne 'expression' -or
            $spec.package.metadata.license.InnerText -ne 'Apache-2.0') { throw 'Package license must be Apache-2.0.' }
        $expected = @{
            'LICENSE' = 'LICENSE'
            'NOTICE' = 'NOTICE'
            'LICENSE.txt' = 'src/SQLineage.Grammar.PlSql/Grammar/LICENSE.txt'
            'NOTICE.md' = 'src/SQLineage.Grammar.PlSql/Grammar/NOTICE.md'
        }
        foreach ($name in $expected.Keys) {
            $entry = $zip.GetEntry($name)
            if ($null -eq $entry) { throw "Missing required attribution file: $name" }
            $stream = $entry.Open()
            try { $actualHash = (Get-FileHash -InputStream $stream -Algorithm SHA256).Hash } finally { $stream.Dispose() }
            $expectedHash = (Get-FileHash -LiteralPath (Join-Path $root $expected[$name]) -Algorithm SHA256).Hash
            if ($actualHash -ne $expectedHash) { throw "Package attribution changed: $name" }
        }
        Write-Output "Verified Apache-2.0 metadata and preserved license/notices: $($package.Name)"
    }
    finally { $zip.Dispose() }
}
