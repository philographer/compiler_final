digit [0-9] /* 변수화, id에서 사용 */
alphabets [A-Za-z] /* 변수화, id에서 사용 */
id {alphabets}({alphabets}|{digit})* /* identifier */
number {digit}+(\.{digit}+)?(E[+\-]?{digit}+)? /* 가독성을 증가시킴 */
%%
{number} {return NUMBER;}
{id} 	{return ID;}
"+" 	{return ADD;}
"-" 	{return SUB;}
"*" 	{return MUL;}
"/" 	{return DIV;}
"=" 	{return ASSIGN;}
"\n" 	{return EOL;}
";" 	{return SEMICOLON;}
"int" 	{return INT;}
"float" {return FLOAT;}
%%