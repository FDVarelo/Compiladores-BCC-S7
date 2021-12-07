%{
%}

INICIO "comecar"
FIM "acabar"
INT [0-9]+
NUM [0-9]+\.?[0-9]*
CHAR [a-zA-Z]+
VAR "@"({CHAR}|{INT}|"_")*","?
IMPRIMIR "imprimir"
IMPRIMIR_EST "imprimir_est"
LER "ler"
LER_EST "ler_est"
IF "se"
ELSE "se_nao"
WHILE "enquanto"

STRING \"[^\"]*\"
TIPO {ESPACO}?("inteiro"|"flutuante"|"estringue")
MENSAGEM "mensagem"
FIM_LINHA "fim_linha"
COMENTARIO "//".*  
ESPACO [\ ]
INVALID (.)

%%


{INICIO} {return INICIO;}
{FIM} {return FIM;}
{MENSAGEM} {return MENSAGEM;}
{FIM_LINHA} {return FIM_LINHA;}
{LER} {return LER;}
{LER_EST} {return LER_EST;}
{IMPRIMIR} {return IMPRIMIR;}
{IMPRIMIR_EST} {return IMPRIMIR_EST;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{STRING} {
    for(int x=0; x<strlen(yytext); x++){
        yytext[x] = yytext[x+1];
    }
    yytext[strlen(yytext)-1] = '\0';
    strcpy(yylval.str, yytext);
    return STRING;
}			
{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
	}
{VAR} {
	strcpy(yylval.str,yytext);
	return VAR;
	}
[-+()=/*^{};] {return *yytext;}

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"<>" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }

{COMENTARIO} {;}
[\ \n\t]*	{;}
{INVALID} {;}
%%