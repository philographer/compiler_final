digit [0-9]
alpha [A-Za-z]
identifier {alpha}({alpha}|{digit})*
number {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?
%%
"+" {return ADD;}
"-" {return SUB;}
"*" {return MUL;}
"/" {return DIV;}
"=" {return ASSIGN;}
";" {return SEMICOLON;}
"\n" {return EOL;}
"int" {return INT;}
"float" {return FLOAT;}
{number} {return NUMBER;}
{identifier} {return ID;}
%%