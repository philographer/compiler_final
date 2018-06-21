%{
/* C Header Definition */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>
	
/* Function Definition */
void IDpusher();
void push();
void threeAddress();
void assignOperator();
void leftMinus();
int yyerror(char const* str);
void insert(int input);
void textCopy();
int getSymbol(char* search);
void fileWrite();

/* Variable Definition */
int i = 0, j = 0;
char symbol[100][100], temp[100];
int type[100];
int tempNum = 0; // current pointer ex) t0, t1, t2 ... temp value
int out;
char tempString[200];
char stack[100][10];
int topOfStack = 0;
%}
/* Named Token */
%token ID NUMBER SEMICOLON INT FLOAT EOL
%left ADD SUB
%left MUL DIV
%left UMINUS
%right ASSIGN
%%
start : L 
| start L
;

L : DECLARE
| expr
| EOL
;

DECLARE : INT ID{textCopy(); printf("int declare\n");insert(0);} END
| FLOAT ID{textCopy(); printf("float declare\n"); insert(1);} END
;

stmt : stmt ADD{push();} term{threeAddress();}
| stmt SUB{push();} term{threeAddress();}
| term
;

term : term MUL{push();} factor{threeAddress();}
| term DIV{push();} factor{threeAddress();}
| factor
;

factor : '('stmt')'
| SUB{push();}factor{leftMinus();} %prec UMINUS
| ID{IDpusher();}
| NUMBER{push();}
;

expr : ID{IDpusher();} ASSIGN{push();} stmt{assignOperator();} END
;

END : SEMICOLON
;
%%
#include "lex.yy.c"
void IDpusher() {
    if(getSymbol(yytext)){
        strcpy(stack[++topOfStack], yytext);
        printf("id pushed! : %s\n", yytext);
    }
    else{
        printf("ERROR!\n%s is unknown id\n", yytext);
        exit(1);
    }
}
void push() {
    strcpy(stack[++topOfStack], yytext);
}

void threeAddress() {
    sprintf(tempString,"t%d = %s %s %s\n", tempNum, stack[topOfStack-2], stack[topOfStack-1], stack[topOfStack]);
    fileWrite();
    topOfStack -= 2;
    sprintf(tempString,"t%d", tempNum);
    strcpy(stack[topOfStack], tempString);
    tempNum++;
}

void assignOperator() {
    sprintf(tempString,"%s = %s\n", stack[topOfStack-2], stack[topOfStack]);
    fileWrite();
    if(type[topOfStack-2] != type[topOfStack]) {
        printf("//warning: type mismatch\n");
        sprintf(tempString,"//warning: type mismatch");
        fileWrite();
	}
    topOfStack -= 2;
}

void leftMinus() {
    sprintf(tempString, "t%d = -%s\n", tempNum, stack[topOfStack]);
    fileWrite();
    topOfStack--;
    sprintf(tempString, "t%d", tempNum);
    strcpy(stack[topOfStack], tempString);
    tempNum++;
}

int yyerror(char const* str) {
    extern char * yytext;
    fprintf(stderr, "parsing error near %s\n", yytext);
    return 0;
}

// input:0 -> int type
// input:1 -> float type
void insert(int input) {
    for(j = 0; j < i; j++) {
        if(strcmp(temp, symbol[j]) == 0){
            if(type[i] == input) {
                printf("ERROR!\n%s is already declared\n", temp);
                exit(1);
            }
            else {
                printf("ERROR!\nMultiple Declaration of Varible\n");
                exit(1);
            }
        }
    }
    printf("%s is inserted\n", temp);
	type[i] = input;
	strcpy(symbol[i], temp);
	i++;
}

void textCopy() {
    strcpy(temp, yytext);
}

int getSymbol(char* search) {
    for(j = 0; j < i; j++) {
        if(strcmp(search, symbol[j]) == 0) {
            return 1;
        }
    }
    return 0;
}

void fileWrite() {
    write(out, tempString, strlen(tempString));
    memset(tempString, 0, 200);
}

int main(int argc, char **argv) {
    extern int yyparse(void);
    extern FILE *yyin;
    
    yyin = fopen(argv[1], "r+");
    if(yyin == NULL) {
        printf("file open error\n");
    }
    out = open("result", O_CREAT | O_RDWR | O_TRUNC , 00777);
    
    while(yyparse()) {
        fprintf(stderr, "Error! at parsing\n");
        exit(1);
    }
}