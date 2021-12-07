# Compiladores-BCC-S7
Atividade final da cadeira de Compiladores do curso de Bacharelado em Ciências da Computação, onde temos que criar um compilador funcional.



Como Rodar
============

Primeiramente este código foi criado e testado apenas em plataforma Linux mais especificamente Ubuntu.
Já no caso do Windows não foi possivel executar o código, porém tem algumas maneiras de como executar um yacc no Windows, porém esse não é o intuito.

Iremos utilizar o VSCode e baixar a extensão: faustinoaq.lex-flex-yacc-bison

Para realmente rodar o código, você tem que abrir o terminal do VSCode ou qualquer outro que você estiver utilizando, e digitar:

```bash
$ make
```

Após isso o proprio compilador vai rodar o exemplo.txt que você escolheu.
Para alterar e escolher outro, você tem que ir para as linhas finais do compiladores_n2.y:

```bash
int main(){
	//yyin=fopen("exemplo.txt","r");
	yyin=fopen("media_ifce.txt","r");
	//yyin=fopen("testes.txt","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}
```
Como podemos ver nos apenas lemos os arquivos .txt, temos três exemplos disponiveis, exemplo.txt que é o exemplo de teste simples, que contém declaração de variavel, print na tela, leitura do teclado, soma, media, print de variavel, e por fim condições (if e else). No média_ifce.txt faz a média ponderada e utiliza de diferente do exemplo.txt o while, e por fim o testes.txt que é um teste de tudo que pode ser feito com o compilador.

Para definirmos uma variavel temos que inicia-lá com algum valor, o mesmo caso vale para string, porém quando for ler ou imprimir string utilizamos uma forma diferente do que utilizados em números inteiros e reais.


Inicio e Fim do código[Sempre sera necessário ter para que ele identifique o que realmente é o código para compilar]:
```bash
  comecar
  <code>
  acabar
```
Inteiro:
```bash
  inteiro @int = 15
  imprimir(@int)
```
Real(Float):
```bash
  inteiro @flutuante = 15.5
  imprimir(@flutuante)
```
String:
```bash
  estringue @string = 0
  ler_est(@string)
  imprimir_est(@string) 
```
Condições(if / else):
```bash
  se(@nota < 7){
      mensagem("Reprovado")
  }se_nao{
      se(@freq>=75){
          mensagem("Aprovado")
      }se_nao{
          mensagem("Reprovado")
      }
  }
```
Prints [Existem dois tipos, mensagem() que vai imprimir na tela do usuario e não pula linha, e imprimir() que vai imprimir o valor de uma variavel]:
```bash
  mensagem("Hello world")
  fim_linha()
  imprimir(@var1)
```
Pular linha [Utilizado separadamente do mensagem(), caso queira imprimir algum texto e depois pedir uma leitura do teclado na mesma linha]:
```bash
  mensagem("Digite sua idade: ")
  ler(@idade)
  fim_linha()
```

Vale resaltar que qualquer nome como mensagem() e outros, podem ser alterados basta você alterar tanto no compiladores_n2.l e compiladores_n2.y em que tem o mesmo nome, e para saber qual é o nome que  deve ser alterado basta ver o nome entre aspas duplas, vale resaltar que o mesmo ocorre com o token em caps lock voce também tem que alterar nos dois arquivos: MENSAGEM "mensagem".

Caso queira alterar o nome do arquivo não tem problema, porém fique ciente de que tem que alterar no arquivo makefile também, e no momento que você rodar o código ira ser criado 3 arquivos extras, 'lex.yy.c', 'compiladores_n2.tab.c' e um chamado 'compilador'. Todos eles podem ser excluidos, pois eles são gerados toda vez que você roda o makefile, e caso você altere o nome dos arquivos principais, esses arquivos extras mudarão de nome então é bom você excluir esses arquivos extras quando mudar de nome, para que não tenha diversos arquivos juntos.
