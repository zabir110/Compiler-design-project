

%{
	#include<stdio.h>
	#include <string.h>
	#include "1507110.tab.h"
	#include<stdlib.h>

	int user_function=0,
	keyword=0,identifiers=0,
	arithmatic_operator=0,
	unary_operator=0,logical_operator=0,
	relational_operator=0,assignment_operator=0,
	library_function=0,datatype=0,_loop=0,cndstatement=0,
	integer=0,floatnum=0,string=0,scmnt=0,mcmnt=0,newl=0;

%}


unary_operator "~++"|"~--"|"~~"|"~!"|"~+"|"~-"
logical_operator [&][&]|[|][|]|[!][!]
Datatype "int"|"float"
identifiers "prince"[a-zA-Z]([a-zA-Z0-9])*
arithmatic_operator "plus"|"minus"|"mul"|"div"|"exp"
relational_operator "<<"|">>"|"<<="|">>="|"=="|"!="
assignment_operator [=]|"+="|"-="|"/="
import "import "[a-zA-Z]([a-zA-Z0-9])*
library_function "TAKEIN<"|"SHOWOUT>"
user_function "function"
conditional_statement "IF"|"ELSE"|"ELIF"|"WHILE"
integer (-|\+)?[0-9]+
float [+-]?[0-9]+[.][0-9]+|[+-]?[.][0-9]+|[1-9]+e[+-][0-9]+
single_line [/][/].*
multiple_line [ ]*[/][m][/][a-zA-Z0-9!@#*(){}_+-,.:\|?><\n\t ]*[/][m][/]

/*RE and Action*/

%%




"~++"    {unary_operator++;return inc;}

"{"	 { keyword++ ; return LB; }

"}"	  {  keyword++ ; return RB; }

{single_line} {
printf("single line comment\n");
scmnt++;
}

{multiple_line} {
mcmnt++;
printf("multiple_line_comment");
}

"COLON"   {keyword++ ;return COLON;}
"BREAK"    {  keyword++ ;  return BREAK;     }
"CASE"      { keyword++ ;return CASE;      }
"switch"      { keyword++ ;return SWITCH;	}


[0-9]+	{ 
		yylval.number = atoi(yytext);
		return NUM;
	}
"FOR"   {keyword++ ;return FOR;}	

"("	{keyword++ ; return LP; }
")"	{keyword++ ; return RP; }


"DEFAULT"     {  keyword++ ;return DEFAULT; 	}
"WHILE"  {keyword++ ;return WHILE;}
"int"	{ keyword++ ;datatype++;return INT; }
"float"	{ keyword++ ;datatype++;return FLOAT; }
"char"	{ keyword++ ;datatype++;return CHAR; }
":"     {keyword++ ;return COL;}

"cm"	{ keyword++ ;return CM; }
"$$"	{ newl++;keyword++ ;return SM; }

"plus"	{ keyword++ ;arithmatic_operator++; return PLUS; }
"minus"	{ keyword++ ;arithmatic_operator++; return MINUS; }
"mul"	{ keyword++ ;arithmatic_operator++; return MULT; }
"div"	{ keyword++ ;arithmatic_operator++; return DIV; }
"="	    { relational_operator++;keyword++;return ASSIGN;  }
">>"	{ relational_operator++; keyword++ ;return GT; }
"<<"	{ relational_operator++;keyword++ ;return LT; }

[a-z]+  { identifiers++;  yylval.string=strdup(yytext);return VAR; }

"IF"		{ cndstatement++;keyword++ ;return IF;		}
"ELSE"		{ cndstatement++;keyword++ ;return ELSE;		}

"function @fname"	{ keyword++ ;return VOIDMAIN; }

[ \t\n]*	

.	{
	//printf("error: %s\n",*yytext);
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = freopen("a.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();
	printf("\nIdentfiers=%d\narithmatic_operator=%d\nunary_operator=%d\n_logical_operator=%d\nrelational_operator=%d\nassignment_operator=%d\nlibrary_function=%d\ndatatype=%d\nloop=%d\nconditional_statement=%d\ninteger=%d\nfloatnum=%d\nNewLine=%d\nmcmnt=%d\n_user_function=%d\nKeyword=%d\nSingle line comment=%d\n",
	identifiers,arithmatic_operator,unary_operator,logical_operator,relational_operator,assignment_operator,library_function,datatype,_loop,cndstatement,integer,floatnum,newl,mcmnt,user_function,keyword,scmnt);

}

