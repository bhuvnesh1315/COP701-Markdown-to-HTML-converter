%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>
#include<stdlib.h>

char text[500]="\0";
int nlCount=0;      //to count number of line breaks
bool bldFlag=0;
bool itlFlag=0;
bool BI_Flag=0;
char start[50]="\0";
char end[50]="\0";

void incNL();       //to increase value of "nlCount"
void write(char *str);  //to write in html file 
void writeInt(int i);
void writePair(char *str, char *start, char *end, char *);
void writeBI_Pair(char *str);

FILE *out;

int yylex();
int yyerror(char *str);


%}

//below tokens are according to priority

%token H1 H2 H3 H4 H5 H6 
%token TEXT
%token UO_LIST
%token OR_LIST
%token BLD_N_ITL
%token BOLD
%token ITALIC
%token NUM 
%token NEWLINE
%token NATURAL_NEWLINE
%token SPACE
%token WORD
%token OTHER

%type <string> H1
%type <string> H2
%type <string> H3
%type <string> H4
%type <string> H5
%type <string> H6
%type <string> TEXT
%type <string> UO_LIST
%type <string> OR_LIST
%type <string> BLD_N_ITL
%type <string> BOLD
%type <string> ITALIC
%type <string> WORD
%type <number> NUM
%type <string> SPACE
%type <string> NATURAL_NEWLINE
%type <string> NEWLINE

%type <string> sentence
%type <string> next
%type <string> linebreak
%type <string> start
%type <string> natural_linebreak
%type <string> unordered_list
%type <string> ordered_list



%union
{
    char *string;
    int number;
}

%%

program:  start
;

start: %empty {}                            //blank spcae before"|" or %empty is epsilon"
       | next start { printf("\nafter start\n");} 
       ;

next: 
        H1 {write("<h1>");} sentence {printf("done==============%s", $3); write("</h1>");} linebreak  sentence linebreak
      | H2 {write("<h2>");} sentence {write("</h2>");} linebreak  sentence linebreak
      | H3 {write("<h3>");} sentence {write("</h3>");} linebreak  sentence linebreak
      | {write("<p>");} sentence {write("</p>");} linebreak
      | {write("\n<ul>");} unordered_list {write("\n</ul>");}
      | {write("\n<ol>");} ordered_list {write("\n</ol>");}
;

linebreak:   NEWLINE { write("<br>\n"); incNL();} natural_linebreak
           | NATURAL_NEWLINE {write("\n");} natural_linebreak
           | linebreak NEWLINE {write("<br>\n"); incNL();}
;

natural_linebreak: %empty {}
    | NATURAL_NEWLINE {write("\n");} natural_linebreak 
;

sentence: %empty {$$=calloc(1,1);}
      | BLD_N_ITL { BI_Flag=!BI_Flag; if(BI_Flag) {strcpy(start,$1);} else {strcpy(end,$1); writeBI_Pair(text); strcpy(text,"\0");}} sentence
      | BOLD { bldFlag=!bldFlag; if(bldFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"strong"); strcpy(text,"\0");}} sentence
      | ITALIC { itlFlag=!itlFlag; if(itlFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"em"); strcpy(text,"\0");}} sentence
      | SPACE { if(bldFlag || itlFlag || BI_Flag) {strcat(text," ");} else write(" ");} sentence 
      | WORD { if(bldFlag || itlFlag || BI_Flag) strcat(text,$1); else write($1); } sentence {$$=calloc(strlen($1)+strlen($3)+1,1); strcpy($$,$1); strcat($$,$3);}
;

unordered_list:   UO_LIST {write("\n<li>");} sentence {write("</li>");} linebreak
                | unordered_list UO_LIST {write("\n<li>");} sentence {write("</li>");} linebreak
;

ordered_list:   OR_LIST {write("\n<li>");} sentence {write("</li>");} linebreak
                | ordered_list OR_LIST {write("\n<li>");} sentence {write("</li>");} linebreak

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


void writeBI_Pair(char *str)
{

        write("<strong><em>");
        write(str);
        write("</em></strong>");

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
