# This is  h1
This is text of heading 1
## This is  h2
This is text of heading 2

### this is h3
This is text of heading 3

#### this is h4
This is text of heading 4

##### this is h5
This is text of heading 5

###### this is h6
This is text of heading 6

This is a paragraph<br>
Second line of paragraph after br tag  
Third line of paragraph after double space this was a paragraph.<br>
Hello **This is bold** normal text _italic . text_ this was a paragraph.<br>
** Not bold** <br>
**Not bold ** <br>
** Not bold ** <br>
normal text<br> 
_italic . text_<br>
_ not italic_<br>
_not italic _<br>
_ not italic _<br>
this was a paragra ph.<br>
__ALso Bold__<br>
*Also Italic*<br>

***Italic and Bold*** normal text ___another one___<br>


This is an unordered list

* Item 1
* Item 2
* Item 3<br>

+ Item 1
+ Item 2
+ Item 3

- Item 1
- Item 2
- Item 3
This is a numbered list

1. Item 1
1. Item 2
1. Item 3

1. Item 1
2. Item 2
3. Item 3

5. Item 1
3. Item 2
0. Item 3

This is a link [Google]( https://www.maps.google.com).

favorite search engine is [Duck Duck Go](https://duckduckgo.com "The best search engine for privacy").

This is an image ![alt text]( https://images.unsplash.com/photo-1484807352052-23338990c6c6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80 "logo Title test 1")
 




Here is a table

| 0 | 0 | 0  | 0  | 0   | 0   |
|---|---|----|----|-----|-----|
| 0 | 1 | 2  | 3  | 4   | 5   |
| 0 | 2 | 5  | 9  | 14  | 20  |
| 0 | 3 | 9  | 19 | 34  | 55  |
| 0 | 4 | 14 | 34 | 69  | 125 |
| 0 | 5 | 20 | 55 | 125 | 251 |

Here is a code of makefile:
```
output: lex.yy.c yacc.tab.c
	gcc -o output lex.yy.c yacc.tab.c

lex.yy.c: lexer.l
	flex lexer.l

yacc.tab.c: yacc.y
	bison -d yacc.y

clean:
	rm lex.yy.c yacc.tab.c output yacc.tab.h
```

Code of shell file:

```
make
./output  < $1 $2
exist=`which firefox`
if [ ! -z "$exist" ]
then firefox $2
fi
make clean
```