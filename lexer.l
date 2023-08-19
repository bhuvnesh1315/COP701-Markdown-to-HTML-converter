%{
#include<stdio.h>
#include<string.h>
#include"yacc.tab.h"

void throwError();		
%}

letter [a-zA-Z]
digit  [0-9]
space  [" "]
h1     [#]
h2     [#][#]
h3     ([#][#][#])
h4     ([#][#][#][#])
h5     ([#][#][#][#][#])
h6     ([#][#][#][#][#][#])
wrd    ({letter}|{digit}|[.])+
txt    ({wrd}|{space})+
numbers ([0-9])+
nline  ("<br>"|({space}{space}"\n"))
%%

{h1}			   {yylval.string = strdup(yytext); return (H1);}	
{h2}			   {yylval.string = strdup(yytext); return (H2);}
{h3}			   {yylval.string = strdup(yytext); return (H3);}
{h4}			   {yylval.string = strdup(yytext); return (H4);}
{h5}			   {yylval.string = strdup(yytext); return (H5);}
{h6}			   {yylval.string = strdup(yytext); return (H6);}
{space}             {return(SPACE);}
"**"              {yylval.string = strdup(yytext); return (BOLD);}
{wrd}              {yylval.string = strdup(yytext); return (WORD);}
"_"              {yylval.string = strdup(yytext); return (ITALIC);}
{nline}      		   {return(NEWLINE);}
"\n"                {return(NATURAL_NEWLINE);}
.      		     {throwError(); return(OTHER);}
%%
//above rules are according to priority

void throwError()
{
    printf("Other I/P");
}
int yywrap()
{
    return 1;
}
