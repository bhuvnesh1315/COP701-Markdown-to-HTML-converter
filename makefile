output: lex.yy.c yacc.tab.c
	gcc -o output lex.yy.c yacc.tab.c

lex.yy.c: lexer.l
	flex lexer.l

yacc.tab.c: yacc.y
	bison -d -Wnone yacc.y

clean:
	rm lex.yy.c yacc.tab.c output yacc.tab.h