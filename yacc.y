%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>

char text[500]="\0";
int nlCount=0;      //to count number of line breaks
bool pairFlag=0;
char start[50]="\0";
char end[50]="\0";

void incNL();       //to increase value of "nlCount"
void write(char *str);  //to write in html file 
void writeInt(int i);
void writePair(char *str, char *start, char *end, char *);

FILE *out;

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
       | next linebreak { /*write("lb="); writeInt(nlCount); nlCount=0;*/} start { printf("\nafter start\n");} 
       ;

next: 
        H1 {write("<h1>");} sentence {write("</h1>");} linebreak { /*write("lb="); writeInt(nlCount); nlCount=0; */} sentence 
      | H2 {write("<h2>");} sentence {write("</h2>");} linebreak { /*write("lb="); writeInt(nlCount); nlCount=0; */} sentence 
      | H3 {write("<h3>");} sentence {write("</h3>");} linebreak { /*write("lb="); writeInt(nlCount); nlCount=0; */} sentence 
      | {write("<p>");} sentence {write("</p>");}
;

linebreak:   NEWLINE {write("<br>\n"); incNL();}
           | NATURAL_NEWLINE {write("\n");} NNL
           | linebreak NEWLINE {write("<br>\n"); incNL();} 
;

NNL: %empty
    | NATURAL_NEWLINE {write("\n");} NNL 
;

sentence: %empty 
      | WORD { if(pairFlag) strcat(text,$1); else write($1); } sentence  
      | BOLD { pairFlag=!pairFlag; if(pairFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"strong"); strcpy(text,"\0");}} sentence
      | ITALIC { pairFlag=!pairFlag; if(pairFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"em"); strcpy(text,"\0");}} sentence
      | SPACE { if(pairFlag) {strcat(text," ");} else write(" ");} sentence 
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

void write(char *str)
{
    //printf("%s",str);
    fprintf(out,"%s",str);
}

void writeInt(int i)
{
    //printf("%d",i);
    fprintf(out,"%d",i);
}

void writePair(char *str, char* start, char *end, char *tag)
{
    int len=strlen(str);

    // printf("\n str =%s",str);
    // printf("\n len =%d",len);
    // printf("\n oth =%c",str[0]);
    // printf("\n last =%c",str[len-2]);
    
    if(str[0]==' ' || str[len-1]==' ')
    {
        write(start);
        write(str);
        write(end);
    }
    else
    {
        write("<"); write(tag); write(">");
        write(str);
        write("</"); write(tag); write(">");
    }
}




int main(int argc, char* argv[])
{
    out=fopen(argv[1],"w");
    yyparse();
    fclose(out);

    return 0;
}
