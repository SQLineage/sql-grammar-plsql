# SQLineage.Grammar.PlSql

Independent Oracle SQL/PLSQL grammar assets and a .NET Standard 2.0 project. ANTLR 4.13.1
generated C# is committed; ordinary builds need no Java or generator. Generated types intentionally
remain in the global namespace. Version `0.0.0-local.1` is for migration validation only.

```powershell
dotnet pack src/SQLineage.Grammar.PlSql -c Release -o artifacts/feed
dotnet restore tests/Grammar.Consumer --source artifacts/feed --source https://api.nuget.org/v3/index.json
dotnet run --project tests/Grammar.Consumer -c Release --no-restore
```

CI builds/packs and runs an independent .NET 8 consumer. No publication is configured.
Existing copyright headers, LICENSE, NOTICE and local synonym modifications remain unchanged.
See [provenance](PROVENANCE.md), [LICENSE](src/SQLineage.Grammar.PlSql/Grammar/LICENSE.txt) and
[NOTICE](src/SQLineage.Grammar.PlSql/Grammar/NOTICE.md). No new license is selected.

For a deliberate reviewed upstream update, run from the project directory:

```text
java -jar antlr4-4.13.1-complete.jar -Dlanguage=CSharp -visitor -no-listener -Xexact-output-dir -o Generated Grammar/PlSqlLexer.g4 Grammar/PlSqlParser.g4
```

Review all four generated .cs files with the grammar change; omit .interp/.tokens files.
Run consumers and downstream synonym, prediction-mode and memory tests. Preserve attribution.
