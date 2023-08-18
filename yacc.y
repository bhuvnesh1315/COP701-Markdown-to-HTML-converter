%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>

char text[100]="\0";
int nlCount=0;      //to count number of line breaks
bool bldFlag=0;
bool itlFlag=0;
void incNL();       //to increase value of "nlCount"
int yylex();
int yyerror(char *str);


%}

//below tokens are according to priority

%token H1 H2 H3 H4 H5 H6 
%token TEXT
%token WORD
%token BOLD
%token ITALIC
%token NUM 
%token NEWLINE
%token NATURAL_NEWLINE
%token SPACE
%token OTHER

%type <string> H1
%type <string> H2
%type <string> H3
%type <string> H4
%type <string> H5
%type <string> H6
%type <string> TEXT
%type <string> WORD
%type <string> BOLD
%type <string> ITALIC
%type <number> NUM
%type <string> SPACE

%union
{
    char *string;
    int number;
}

%%

program:  start
;

start: %empty                             //blank spcae before"|" or %empty is epsilon"
       | next linebreak { printf("\n lb=%d \n",nlCount); while(nlCount--); nlCount=0;} start { printf("\nafter start\n");} 
       ;

next: 
        H1 sentence {printf("<h1>%s</h1>",text); strcpy(text,"\0");} linebreak { printf("\n lb=%d \n",nlCount); while(nlCount--); nlCount=0;} sentence {printf("%s",text); strcpy(text,"\0");}
      | H2 sentence {printf("<h2>%s</h2>",text); strcpy(text,"\0");} linebreak { printf("\n lb=%d \n",nlCount); while(nlCount--); nlCount=0;} sentence {printf("%s",text); strcpy(text,"\0");}
      | H3 sentence {printf("<h3>%s</h3>",text); strcpy(text,"\0");} linebreak { printf("\n lb=%d \n",nlCount); while(nlCount--); nlCount=0;} sentence {printf("%s",text); strcpy(text,"\0");}
      | sentence {printf("<p>%s</p>",text); strcpy(text,"\0");}
;

linebreak:   NEWLINE {incNL();}
           | NATURAL_NEWLINE { printf("\n");} 
           | linebreak NEWLINE {incNL();} 
;

sentence: %empty 
      | WORD { strcat(text,$1);} sentence  
      | BOLD { bldFlag=!bldFlag; if(bldFlag) strcat(text,"<strong>"); else strcat(text,"</strong>");} sentence
      | ITALIC { itlFlag=!itlFlag; if(itlFlag) strcat(text,"<em>"); else strcat(text,"</em>");} sentence
      | SPACE { strcat(text," ");} sentence 
;
%%
int yydebug=1;

int yyerror(char *str)
{
		printf("Error: %s\n", str);
	return 0;
}

void incNL()
{
    nlCount++;
}

int main()
{
    yyparse();
    return 0;
}
