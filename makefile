default:
	flex lexer.l
	bison -d yacc.y
	gcc -o output lex.yy.c yacc.tab.c
	./output  < markdown.md > output_file.html