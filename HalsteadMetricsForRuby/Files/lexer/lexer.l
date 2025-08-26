%option noyywrap
%x COMMENT

%%

#[^\n]*	{}
"=begin"	BEGIN(COMMENT);{}
<COMMENT>"=end"	BEGIN(INITIAL);{}	
<COMMENT>.|"\n"	{}

[\n\t ]*	{}


("module"|"class")" "[^\n]*	{ printf("Declaration: \n%s\n", yytext); }
("def"|"alias"|"undef")[^a-zA-Z].*[\n\t ]*	{ printf("Declaration: \n%s\n", yytext); }


"private"|"protected"|"public"|"rescue"|"ensure"|"end"|"do"|"else"|"elsif"|"then"|"when"|"include"|"lambda"	{}
("attr_accessor"|"attr_reader"|"attr_writer").*|"proc"|")"|"}"|[a-zA-Z0-9]+":".*\n|"|"[a-zA-Z0-9_]+"|"|" : "|","	{}


"BEGIN"[^{]*"{"|"END"[^{]*"{"|"begin"|"break"|"retry"|"redo"|"next"|"require"|"return"|"for".*"in"|"yield"|"in"|"while"|"until"|"if"|"unless"|"case"|"puts"|"each"|"times"|"raise"|"map"|"select"|"super"("("?)	{printf("Operator: \n%s\n", yytext);}
"?"|"("|"."|"+"|"-"|"*"|"/"|"%"|"**"|"="|"+="|"-="|"*="|"/="|"%="|"**="|"=="|"==="|"<=>"|">="|"<="|"!="|"<"|">"|"or"|"and"|"not"|"&&"|[|]{1,2}|"^"|"!"|"~"|"<<"|">>"|"&"|"^"|"|"|"&="|"|="|"^="|"<<="|">>="|"=>"|[a-zA-Z_][a-zA-Z_0-9]*"("|"("|"{"	{printf("Operator: \n%s\n", yytext);}



"nil"|"true"|"false"|"self"|"defined?("|((":"?)|("$"?)|("@"{0,2}))[a-zA-Z_][a-zA-Z_0-9]*|":"?"\""([^\"\n]("\\\n")?)*"\""|":"?"'"([^\"\n])*"'"|"("?[0-9]+(".."|"...")[0-9]+")"?	{ printf("Operand: \n%s\n", yytext);}

"%"?[qQiIxwWsr]?"[".*("]"([\n\t ]|"."))|"0"[oObBxX]([0-9A-Fa-f])("_"?[0-9A-Fa-f])*|[0-9]("_"?[0-9])*|[0-9]+"."[0-9]+((e|E)("+"|"-")?[0-9]+)?	{ printf("Operand: \n%s\n", yytext);}


%%

int main()
{
	yylex();
	printf("Declaration: \ndef super\n");
	printf("Declaration: \ndef call\n");
	printf("Declaration: \ndef map\n");
	printf("Declaration: \ndef select\n");
}