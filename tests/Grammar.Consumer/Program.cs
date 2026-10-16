using Antlr4.Runtime;

var lexer = new PlSqlLexer(new AntlrInputStream("CREATE NONEDITIONABLE PUBLIC SYNONYM current_orders FOR app.orders;"));
var parser = new PlSqlParser(new CommonTokenStream(lexer));
var tree = parser.sql_script();
if (parser.NumberOfSyntaxErrors != 0 || tree.ChildCount == 0) { return 1; }
Console.WriteLine("Standalone netstandard2.0 grammar consumed successfully by a net8.0 application.");
return 0;
