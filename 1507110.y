

%{
	
	#include<stdio.h>
	
	int cnt=1,cntt=0,val;

	typedef struct entry {
    char *str;
    int n;
	}object;

	object storevariable[1000],value[1000];
	void firstinsert (object *p, char *s, int n);	
	int cnt2=1; 
	void secondinsert (object *p, char *s, int n);
	
%}
%union 
{
        int number;
        char *string;
}

/* BISON Declarations */

%token <number> NUM
%token <string> VAR 
%token <string> IF ELSE VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV ASSIGN FOR COL WHILE BREAK COLON DEFAULT CASE SWITCH inc importtt inpit
%type <string> statement
%type <number> expression
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV




/* Simple grammar rules */

%%

program: VOIDMAIN LP RP LB codesection RB { printf("\nsuccessful compilation\n"); }
	 ;

codesection: /* empty */

	| codesection statement
	
	| variabledeclaration
	;

variabledeclaration :	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }
		| importtt inpit SM    ;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						if(checking_variable($3) == 1)
						{
							printf("%s is already declared\n", $3 );
						}
						else
						{
							firstinsert(&storevariable[cnt],$3, cnt);
							cnt++;
							
						}
					}

     | VAR		{

				if(checking_variable($1) == 1)
				{
					printf("%s is already declared\n", $1  );
				}
				else
				{
					firstinsert(&storevariable[cnt],$1, cnt);
							cnt++;
				}
			}
     ;





statement: SM

	| SWITCH LP expression RP LB INSIDE RB    {printf("SWITCH case.\n");val=$3;} 

	| expression SM 			{ printf("\nvalue of expression: %d\n", ($1)); }

    | VAR ASSIGN expression SM 		{

							if(checking_variable($1)){
							secondinsert(&value[$3], $1, $3);
							
							printf("\n(%s) Value of the variable: %d\t\n",$1,$3);
							}
							else {
							printf("%s not declared yet\n",$1);
							}
							
						}

	| IF LP expression RP LB statement SM RB %prec IFX {
								if($3)
								{
									printf("\nvalue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\ncondition value zero in IF block\n");
								}
							}

	| IF LP expression RP LB statement SM RB ELSE LB statement SM RB {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$11);
									}
								   }

	| FOR LP NUM COL NUM RP LB expression RB     {

	   int i=0;
	   for(i=$3;i<$5;i++){
	   printf("for loop statement\n");
	   }
	}

	
	;
//--------------------------------switch---------------------------------------------------
	
			INSIDE : Base   
				 | Base Dflt 
				 ;

			Base   : /*NULL*/
				 | Base Cse     
				 ;

			Cse    : CASE NUM COL expression SM   {
				
						if($2==2){
							  cntt=1;
							  printf("\nCase No : %d  and Result :  %d\n",$2,$4);
						}
					}
				 ;

			Dflt    : DEFAULT COLON NUM SM    {
						if(cntt==0){
							printf("\nResult in default Value is :  %d \n",$3);
						}
					}
				 ;    
	//---------------------------------------------------------------------------------------------------
	
	
expression: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = checking_variable2($1); printf("Variable value: %d",$$)}

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}

	| inc expression inc         { $$=$2+1; printf("inc: %d\n",$$);}
	;
%%


///////------------------------------------------------------------------------
void firstinsert (object *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int
checking_variable(char *key)
{
    int i = 1;
    char *name = storevariable[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return storevariable[i].n;
        name = storevariable[++i].str;
    }
    return 0;
}
/////////////////////////-------------------------------------------------------
void secondinsert (object *p, char *s, int n)
{
  p->str = s;
  p->n = n;
 
}

int
checking_variable2(char *key)
{
    int i = 1;
    char *name = value[i].str;
	int cnt4=100;
    while (cnt4--) {
        if (strcmp(name, key) == 0)
            return value[i].n;
        name = value[++i].str;
    }
	
    return 0;
	
}

///////////////////////////---------------------------------------------------------


int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

