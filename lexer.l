%{
#include<stdio.h>
#include<string.h>
#include"yacc.tab.h"

void throwError();		
%}

letter      [a-zA-Z]
digit       [0-9]
space       [" "]
h1          [#]
h2          [#][#]
h3          ([#][#][#])
h4          ([#][#][#][#])
h5          ([#][#][#][#][#])
h6          ([#][#][#][#][#][#])
bold_N_itl  ("***"|"___")
special     ([~`!@#$%^&+=|\\:;"',>\.?\/-])
wrd         ({letter}|{digit}|{special})+
txt         ({wrd}|{space})+
nline       ("<br>"|({space}{space}"\n"))
url         (http:\/\/www\.|https:\/\/www\.|https:\/\/|http:\/\/)?({letter}|{digit})+(\.({letter}|{digit})+)+(\.({letter}|{digit})+)+
%%

{h1}			    {yylval.string = strdup(yytext); return (H1);}	
{h2}			    {yylval.string = strdup(yytext); return (H2);}
{h3}			    {yylval.string = strdup(yytext); return (H3);}
{h4}			    {yylval.string = strdup(yytext); return (H4);}
{h5}			    {yylval.string = strdup(yytext); return (H5);}
{h6}			    {yylval.string = strdup(yytext); return (H6);}
("* "|"- "|"+ ")    {yylval.string = strdup(yytext); return (UO_LIST);}
{digit}"."{space}   {yylval.string = strdup(yytext); return (OR_LIST);}
{space}             {return(SPACE);}
{bold_N_itl}        {yylval.string = strdup(yytext); return (BLD_N_ITL);}
"**"|"__"           {yylval.string = strdup(yytext); return (BOLD);}
"*"|"_"             {yylval.string = strdup(yytext); return (ITALIC);}
"["                 {return (OPEN_SQR);}
"]"                 {return (CLOSE_SQR);}
"("                 {return (OPEN_CRV);}
")"                 {return (CLOSE_CRV);}
{url}               {yylval.string = strdup(yytext); return (LINK);}
{wrd}               {yylval.string = strdup(yytext); return (WORD);}
{nline}      	    {return(NEWLINE);}
"\n"                {return(NATURAL_NEWLINE);}
.      		        {throwError(); return(OTHER);}
%%
//priority is accordin to longest pattern match

void throwError()
{
    printf("Other I/P");
}
int yywrap()
{
    return 1;
}
