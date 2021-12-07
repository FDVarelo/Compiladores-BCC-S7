%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>	
		
/*O node type serve para indicar o tipo de nó que está na árvore. Isso serve para a função eval() entender o que realizar naquele nó*/
typedef struct ast { /*Estrutura de um nó*/
	int nodetype;
	struct ast *l; /*Esquerda*/
	struct ast *r; /*Direita*/
}Ast; 

typedef struct numval { /*Estrutura de um número*/
	int nodetype;
	double number;
}Numval;

typedef struct varval { /*Estrutura de um nome de variável, nesse exemplo uma variável é um número no vetor var[26]*/
	int nodetype;
	char var[50];
}Varval;

typedef struct flow { /*Estrutura de um desvio (if/else/while)*/
	int nodetype;
	Ast *cond;		/*condição*/
	Ast *tl;		/*then, ou seja, verdade*/
	Ast *el;		/*else*/
}Flow;

typedef struct symasgn { /*Estrutura para um nó de atribuição. Para atrubior o valor de v em s*/
	int nodetype;
	char s[50];
	Ast *v;
}Symasgn;

typedef struct var {
	int nodetype;
	char name[51];
	float valor;
	char valors[50];
	struct var *prox;
} Var;

typedef struct textoval { /*Estrutura de uma variavel texto*/
        int nodetype;
        char v[1000];
}Textoval;

Var *l1; /*Variáveis*/
Var *aux;
	
Var *ins(Var*l,char n[]){ //insere uma nova variável na lista de variáveis
		Var*new =(Var*)malloc(sizeof(Var));
		strcpy(new->name, n);
		new->valor = 0;
		new->prox = l;
		return new;
}

Var *srch(Var*l,char n[]){	//busca uma variável na lista de variáveis
		Var*aux = l;
		while(aux != NULL){
			if(strcmp(n,aux->name)==0)
				return aux;
			aux = aux->prox;
		}
		return aux;
}

Ast * newast(int nodetype, Ast *l, Ast *r){ /*Função para criar um nó*/
	Ast *a = (Ast*) malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;
	a->l = l;
	a->r = r;
	return a;
}
 
Ast * newvari(int nodetype, char nome[50]) {			/*Função de que cria uma nova variável*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = nodetype;;
	strcpy(a->var,nome);
	return (Ast*)a;
}

Ast * newnum(double d) {			/*Função de que cria um novo número*/
	Numval *a = (Numval*) malloc(sizeof(Numval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'K';
	a->number = d;
	return (Ast*)a;
}	
 
Ast * newtexto(char d[]) { /*Função de que cria um novo texto (folha)*/
    Textoval *a = (Textoval*) malloc(sizeof(Textoval));
    if(!a) {
        printf("out of space");
        exit(0);
    }
    a->nodetype = 'm';
    strcpy(a->v, d);
    return (Ast*)a;
}
	
Ast * newflow(int nodetype, Ast *cond, Ast *tl, Ast *el){ /*Função que cria um nó de if/else/while*/
	Flow *a = (Flow*)malloc(sizeof(Flow));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = nodetype;
	a->cond = cond;
	a->tl = tl;
	a->el = el;
	return (Ast *)a;
}

Ast * newcmp(int cmptype, Ast *l, Ast *r){ /*Função que cria um nó para testes*/
	Ast *a = (Ast*)malloc(sizeof(Ast));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	a->nodetype = '0' + cmptype; /*Para pegar o tipo de teste, definido no arquivo.l e utilizar na função eval()*/
	a->l = l;
	a->r = r;
	return a;
}

Ast * newasgn(char s[50], Ast *v) { /*Função para um nó de atribuição*/
	Symasgn *a = (Symasgn*)malloc(sizeof(Symasgn));
	if(!a) {
		printf("out of space");
	exit(0);
	}
	Var *aux = srch(l1, s);
	if(aux == NULL)
		l1 = ins(l1, s);
	a->nodetype = '=';
	strcpy(a->s,s);
	//a->s = s; /*Símbolo/variável*/
	a->v = v; /*Valor*/
	return (Ast *)a;
}

Ast * newValorVal(char s[50]) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'N';
	strcpy(a->var,s);
	return (Ast*)a;
}

Ast * newValorValS(char s[50]) { /*Função que recupera o nome/referência de uma variável, neste caso o número*/
	Varval *a = (Varval*) malloc(sizeof(Varval));
	if(!a) {
		printf("out of space");
		exit(0);
	}
	a->nodetype = 'Q';
	strcpy(a->var,s);
	return (Ast*)a;
}

char * eval2(Ast *a) { /*Função que executa operações a partir de um nó*/
		Var *aux1;
		char *v2;
			switch(a->nodetype) {
			case 'Q':
				aux1 = srch(l1,((Varval *)a)->var);
				return aux1->valors;
				break;
			default: printf("internal error: bad node %c\n", a->nodetype);
					break;
		}		
	return v2;
}

double eval(Ast *a) { /*Função que executa operações a partir de um nó*/
	double v; 
	char v1[50];
	char *v2;
	Var * aux1;
	if(!a) {
		printf("internal error, null eval");
		return 0.0;
	}
	switch(a->nodetype) {
		case 'K': v = ((Numval *)a)->number; break; 	/*Recupera um número*/
		case 'm': v = atof(((Textoval *)a)->v); break; 	/*Recupera um número real dentro de string*/
		case 'N': 
			aux1 = srch(l1,((Varval *)a)->var);
			v = aux1->valor;
			break;
		case '+': v = eval(a->l) + eval(a->r); break;	/*Operações "árv esq   +   árv dir"*/
		case '-': v = eval(a->l) - eval(a->r); break;	/*Operações*/
		case '*': v = eval(a->l) * eval(a->r); break;	/*Operações*/
		case '/': v = eval(a->l) / eval(a->r); break; /*Operações*/
		case '^': v = pow(eval(a->l), eval(a->r)); break; /*Operações*/
		case '#': v = pow(eval(a->l), (1 / eval(a->r))); /*Operações*/
      break;
		case 'M': v = -eval(a->l); break;				/*Operações, número negativo*/
		case '1': v = (eval(a->l) > eval(a->r))? 1 : 0; break;	/*Operações lógicas. "árv esq   >   árv dir"  Se verdade 1, falso 0*/
		case '2': v = (eval(a->l) < eval(a->r))? 1 : 0; break;
		case '3': v = (eval(a->l) != eval(a->r))? 1 : 0; break;
		case '4': v = (eval(a->l) == eval(a->r))? 1 : 0; break;
		case '5': v = (eval(a->l) >= eval(a->r))? 1 : 0; break;
		case '6': v = (eval(a->l) <= eval(a->r))? 1 : 0; break;
		case '=':
			// inicialmente verificar se a variável existe
			v = eval(((Symasgn *)a)->v); /*Recupera o valor*/
			aux = srch(l1,((Symasgn *)a)->s);
			aux->valor = v;			
			break;	
		case 'I':						/*CASO IF*/
			if (eval(((Flow *)a)->cond) != 0) {	/*executa a condição / teste*/
				if (((Flow *)a)->tl)		/*Se existir árvore*/
					v = eval(((Flow *)a)->tl); /*Verdade*/
				else
					v = 0.0;
			} else {
				if( ((Flow *)a)->el) {
					v = eval(((Flow *)a)->el); /*Falso*/
				} else
					v = 0.0;
				}
			break;
		case 'S': 	scanf("%lf",&v);
					aux1 = srch(l1,((Varval *)a)->var);
					aux1->valor = v;
					break;
		case 'W':
			v = 0.0;
			if( ((Flow *)a)->tl) {
				while( eval(((Flow *)a)->cond) != 0){
					v = eval(((Flow *)a)->tl);
				}
			}
		break;
		case 'L': 	eval(a->l);
					v = eval(a->r);
					break; /*Lista de operções em um bloco IF/ELSE/WHILE. Assim o analisador não se perde entre os blocos*/
		case 'P': 	v = eval(a->l);		/*Recupera um valor*/
					int intpart = (int)v; /*(int)v ira pegar apenas a parte inteira do v*/
					double decpart = v - intpart; /*pega v - parte inteira, ex: 15.5 - 15 = 0.5*/
					if (decpart==0.00){printf("%d\n",intpart);} /*se o decpart(decimal) for 0, printa apenas a parte inteira*/
					else{printf("%.2f\n",v);} /*caso o decpart(decimal) for diferente de 0, printamos o v == num == 15.5*/
					break;
		case 'V': 	l1 = ins(l1,((Varval*)a)->var);
					break;
		case 'T': 	printf("%s\n", ((Textoval*)a->l)->v);
					break;
		case 'Q': 	printf("\n");
					break;
		case 'Y':	v2 = eval2(a->l);		/*Recupera um valor STR*/
					printf ("%s\n",v2); break;  /*Função que imprime um valor (string)*/
					break;			
		case 'Z': 	scanf("%s",v1);
					aux1 = srch(l1,((Varval *)a)->var);
					strcpy(aux1->valors,v1);
					break;
		case 'J': 	if(((Textoval*)a->l)->nodetype == 'm') {
						if(((Textoval*)a->l)->v == "\n"){
							printf("quebra 123");
						}
                     printf ("%s", ((Textoval*)a->l)->v);
					break;		/*Recupera um valor texto*/
                }		
		default: printf("internal error: bad node %c\n", a->nodetype);		
	}
	return v;
}

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

%}

%union{
	char str[50];
	float flo;
	int fn;
	int inter;
	Ast *a;
	}

%token <flo>NUM
%token <str>TIPO
%token <str>VAR
%token <str> STRING
%token <str> INCREMENTO DECREMENTO
%token MENSAGEM FIM_LINHA
%token INICIO FIM IMPRIMIR IMPRIMIR_EST LER LER_EST IF ELSE WHILE  
%token <fn> CMP

%right '='
%right '^' '#'
%right INCREMENTO DECREMENTO
%left '+' '-'
%left '*' '/'
%left CMP

%type <a> exp exp1 list stmt prog estringue

%nonassoc IFX NEG

%%

val: INICIO prog FIM
	;
prog: stmt 		{eval($1);}  /*Inicia e execução da árvore de derivação*/
	| prog stmt {eval($2);}	 /*Inicia e execução da árvore de derivação*/
	;	
/*Funções para análise sintática e criação dos nós na AST*/	
/*Verifique q nenhuma operação é realizada na ação semântica, apenas são criados nós na árvore de derivação com suas respectivas operações*/
	
stmt: IF '(' exp ')' '{' list '}' %prec IFX{$$ = newflow('I', $3, $6, NULL);}
	
	| IF '(' exp ')' '{' list '}' ELSE '{' list '}'{$$ = newflow('I', $3, $6, $10);}

	| WHILE '(' exp ')' '{' list '}'{$$ = newflow('W', $3, $6, NULL);}

	| MENSAGEM '(' estringue ')' {$$ = $3;} // derivacao para estringue	
		
	| FIM_LINHA '('')' {$$ = newast('Q',NULL,NULL);} // derivacao para estringue	

	| TIPO VAR  { $$ = newvari('V',$2);}
	
    | TIPO VAR '=' exp {$$ = newasgn($2,$4);}

	| VAR '=' exp{$$ = newasgn($1,$3);}

	| IMPRIMIR '(' exp ')' {$$ = newast('P',$3,NULL);}

	| IMPRIMIR_EST '(' exp1 ')' {$$ = newast('Y',$3,NULL);}	

	| LER '(' VAR ')' {$$ = newvari('S',$3);}

	| LER_EST '(' VAR ')' {$$ = newvari('Z',$3);}	
;	

// nó nao-terminal para estringue variaveis de tipos distintos
estringue: 
     
     STRING {$$ = newast('J', newtexto($1), NULL);} 
    ;

list:	  stmt{$$ = $1;}
		| list stmt { $$ = newast('L', $1, $2);	}
		;
	
exp: 
	 exp '+' exp {$$ = newast('+',$1,$3);}		/*Expressões matemáticas*/
	|exp '-' exp {$$ = newast('-',$1,$3);}
	|exp '*' exp {$$ = newast('*',$1,$3);}
	|exp '/' exp {$$ = newast('/',$1,$3);}
	|exp '^' exp {$$ = newast('^',$1,$3);}
	|exp '#' exp {$$ = newast('#',$1,$3);}
	|exp CMP exp {$$ = newcmp($2,$1,$3);}		/*Testes condicionais*/
	|'(' exp ')' {$$ = $2;}
	|'-' exp %prec NEG {$$ = newast('M',$2,NULL);}
	|NUM {$$ = newnum($1);}						/*token de um número*/
	|VAR {$$ = newValorVal($1);}				/*token de uma variável*/
	;

exp1: 
	VAR {$$ = newValorValS($1);}				
	;
%%

#include "lex.yy.c"

int main(){
	
	//yyin=fopen("exemplo.txt","r");
	yyin=fopen("media_ifce.txt","r");
	//yyin=fopen("testes.txt","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}

