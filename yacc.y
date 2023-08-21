%{
#include<stdio.h>
#include<string.h>
#include<stdbool.h>
#include<stdlib.h>
#include<ctype.h>

char text[500]="\0";
int nlCount=0;      //to count number of line breaks
bool bldFlag=0;
bool itlFlag=0;
bool BI_Flag=0;
char start[50]="\0";
char end[50]="\0";

void incNL();           //to increase value of "nlCount"
void write(char *str);  //to write in html file 
void writeInt(int i);
void writePair(char *str, char *start, char *end, char *);
void writeBI_Pair(char *str);
void writeLink(char *text, char *href, char *title);
void writeImage(char *alt, char *src, char *title);

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
%token NEWLINE
%token NATURAL_NEWLINE
%token LINK
%token OPEN_SQR
%token CLOSE_SQR
%token OPEN_CRV
%token CLOSE_CRV
%token EXCLAIM
%token PIPE
%token DASHES
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
%type <string> SPACE
%type <string> NATURAL_NEWLINE
%type <string> LINK
%type <string> OPEN_SQR
%type <string> CLOSE_SQR
%type <string> OPEN_CRV
%type <string> CLOSE_CRV
%type <string> EXCLAIM
%type <string> PIPE
%type <string> DASHES
%type <string> NEWLINE


%union
{
    char *string;
    int number;
}

%%

program:  {write("<!DOCTYPE html>\n<html>\n<head>\n<title>MD2HTML</title>\n<body>\n");} start {write("</body>\n</html>");}
;

start: %empty                             //blank spcae before"|" or %empty is epsilon"
       | next start
       ;

next: 
        H1 {write("<h1>");} sentence {write("</h1>");} linebreak  sentence linebreak
      | H2 {write("<h2>");} sentence {write("</h2>");} linebreak  sentence linebreak
      | H3 {write("<h3>");} sentence {write("</h3>");} linebreak  sentence linebreak
      | H4 {write("<h4>");} sentence {write("</h4>");} linebreak  sentence linebreak
      | H5 {write("<h5>");} sentence {write("</h5>");} linebreak  sentence linebreak
      | H6 {write("<h6>");} sentence {write("</h6>");} linebreak  sentence linebreak
      | {write("<p>");} sentence {write("</p>");} linebreak
      | {write("\n<ul>");} unordered_list {write("\n</ul>");}
      | {write("\n<ol>");} ordered_list {write("\n</ol>");}
      | {write("<table>\n");} table {write("</table>\n");}
;

linebreak:   NEWLINE { write("<br>\n"); incNL();} natural_linebreak
           | NATURAL_NEWLINE {write("\n");} natural_linebreak
           | linebreak NEWLINE {write("<br>\n"); incNL();}
;

natural_linebreak: %empty {}
    | NATURAL_NEWLINE {write("\n");} natural_linebreak 
;

sentence: %empty
      | BLD_N_ITL { BI_Flag=!BI_Flag; if(BI_Flag) {strcpy(start,$1);} else {strcpy(end,$1); writeBI_Pair(text); strcpy(text,"\0");}} sentence
      | BOLD { bldFlag=!bldFlag; if(bldFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"strong"); strcpy(text,"\0");}} sentence
      | ITALIC { itlFlag=!itlFlag; if(itlFlag) {strcpy(start,$1);} else {strcpy(end,$1); writePair(text,start,end,"em"); strcpy(text,"\0");}} sentence
      | SPACE { if(bldFlag || itlFlag || BI_Flag) {strcat(text," ");} else write(" ");} sentence 
      | WORD { if(bldFlag || itlFlag || BI_Flag) strcat(text,$1); else write($1); } sentence /*{$$=calloc(strlen($1)+strlen($3)+1,1); strcpy($$,$1); strcat($$,$3);}*/
      | OPEN_SQR words CLOSE_SQR OPEN_CRV spaces LINK words CLOSE_CRV {writeLink($<string>2,$6,$<string>7);} sentence
      | EXCLAIM OPEN_SQR words CLOSE_SQR OPEN_CRV spaces LINK words CLOSE_CRV {writeImage($<string>3,$7,$<string>8);} sentence
;

table:    {write("<tr>\n");} tab_head {write("</tr>\n");} linebreak separate  linebreak {write("<tr>\n");} tab_data {write("</tr>\n");}
;

tab_head:   PIPE
          | PIPE {write("<th>");} words {write($<string>3); write("</th>\n");} tab_head
;

separate:   PIPE
          | PIPE DASHES separate
;
tab_data: %empty 
          | PIPE linebreak {write("</tr>\n"); write("<tr>\n");} tab_data
          | PIPE {write("<td>");} words {write($<string>3); write("<td>\n");} tab_data
;

spaces: %empty
        | SPACE
;

words:        WORD words {$<string>$=calloc(strlen($<string>1)+strlen($<string>2),1); strcpy($<string>$,$<string>1); strcat($<string>$,$<string>2);}
            | SPACE words {$<string>$=calloc(1+strlen($<string>2),1); strcpy($<string>$," "); strcat($<string>$,$<string>2);}
            | %empty { $<string>$=calloc(1,1);}
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

void writeLink(char *text, char *href, char *title)
{
    write("<a href=\"");
    write(href);
    write("\" title=");
    
    if(strlen(title)>0)
    {
        write(title);
    }
    else
    {
        write("\"\"");
    }
    write(">");
    write(text);
    write("</a>");

}

void writeImage(char *alt, char *src, char *title)
{
    write("<img src=\"");
    write(src);
    write("\" alt=\"");
    write(alt);
    write("\" title=");
    
    if(strlen(title)>0)
    {
        write(title);
    }
    else
    {
        write("\"\"");
    }

    write(">");

}

int main(int argc, char* argv[])
{
    out=fopen(argv[1],"w");
    yyparse();
    fclose(out);

    return 0;
}
