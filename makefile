all : compiladores_n2.l compiladores_n2.y
	clear
	flex -i compiladores_n2.l
	bison compiladores_n2.y
	gcc compiladores_n2.tab.c -o compilador -lfl -lm
	./compilador
