% Maximo de caballos
%
% Este archivo provee predicados para calcular la maxima cantidad
% de caballos a colocar en un tablero y como colocarlos para que
% no sea posible que se ataquen entre ellos
%
% @author Alejandro Diaz

:- dynamic([boardSize/1]).
:- initialization(retractall(boardSize(_))).

%generar todas las posiciones
generarK(K , N , [K|Ks]) :-  siguiente(K , N , K1) , generarK(K1 , N , Ks).
generarK(K , N , [K]):- \+ siguiente(K , N , _). 

%genera el siguiente K, queda unificado en la ultima posicion.
siguiente(k(X , Y) , N , K) :- Y = N , X =< N , Y1 =  1 , X < N , X1 is X + 1, K = k(X1 , Y1).
siguiente(k(X , Y) , N , K) :- Y < N , Y1 is Y+1 , K = k(X , Y1).


%elimina todos los movimientos posibles de la lista
% K es la posicion , Ms es la lista de movimientos posibles , Mns son los movimientos restantes.
removeFromMoves(K , Ms , Mns , S) :-  safeMoves(K , Ks) , removeMove(Ks , Ms , Mns , S).

removeMove([] , M , M  , 0).
removeMove([K|Ks] , Ms , Mns , S) :- deleteOne(Ms , K , R , S1), ! , removeMove(Ks , R , Mns , S2) , S is S1 + S2.

%hago mi propio delete para que no intente eliminar mas de una ocurrencia

deleteOne(Ks , K , Ks , 0) :- \+ safeK(K) , !.
deleteOne([] , _ , [] , 0).
deleteOne([K|Ks] , K , Ks , 1).
deleteOne([K|Ks] , Kx , [K|Krs] , S) :-  deleteOne(Ks , Kx , Krs, S) , !.

safeK(k(X,Y)) :- boardSize(N), ! , X >  0 ,  X =< N ,  Y > 0  ,  Y =< N.

%genera los movimientos posibles desde una posicion inicial
%incluye la posicion inicial, se usa para eliminar coincidencias de la lista
%de caballos por colocar

buildmoves(k(X, Y) , [K1 , K2 , K3, K4 , K5 , K6, K7 , K8]) :-
	leftUp(k(X, Y) , K1),
	leftDown(k(X, Y) , K2),
	rightUp(k(X,Y) , K3),
	rightDown(k(X,Y) , K4),
	upLeft(k(X, Y) , K5),
	upRight(k(X, Y) , K6),
	downLeft(k(X, Y) , K7),
	downRight(k(X, Y) , K8).

leftUp(k(X, Y) , k(Kx , Ky)) :- Kx is X - 1 , Ky is Y - 2.
leftDown(k(X, Y) , k(Kx , Ky)) :- Kx is X + 1 , Ky is Y - 2.
rightUp(k(X, Y) , k(Kx , Ky)) :- Kx is X - 1 , Ky is Y + 2.
rightDown(k(X, Y) , k(Kx , Ky)) :- Kx is X + 1 , Ky is Y + 2.
upLeft(k(X, Y) , k(Kx , Ky)) :- Kx is X - 2 , Ky is Y - 1.
upRight(k(X, Y) , k(Kx , Ky)) :- Kx is X - 2  , Ky is Y + 1.
downLeft(k(X, Y) , k(Kx , Ky)) :- Kx is X + 2 , Ky is Y - 1.
downRight(k(X, Y) , k(Kx , Ky)) :- Kx is X + 2 , Ky is Y + 1.


safeMoves(K , Ks) :- buildmoves(K , Kxs) , filterMoves(Kxs , Ks) , !.

filterMoves([] , []).
filterMoves([K|Ks] , [K|Kxs]) :- safeK(K) , filterMoves(Ks , Kxs).
filterMoves([K|Ks] , Kxs) :- \+ safeK(K) , filterMoves(Ks , Kxs).


%Conteo , Estado resultante, Historia , Movimientos , Objetivo , Cantidad de posibilidades eliminadas hasta el momento
dfs(Ncolocados , Colocados , Colocados , [] , Ncolocados , O , _) :-
	Ncolocados = O.

%colocando la ficha.
dfs(Conteo, Resultado ,  Historia , [Movimiento|Movimientos] , Ncolocados , O , Eliminados) :-
	removeFromMoves(Movimiento  , Movimientos , Posibles , Removidos),
	Ncol is Ncolocados + 1,
	restan(Movimiento , R),
	Nop is Removidos + Eliminados,
	boardSize(N),
	P is (N * N) - Nop, %deberia ser nop, por que no funciona asi?
	P >= O - 1,
	dfs(Conteo , Resultado , [Movimiento|Historia] , Posibles, Ncol , O , Nop).

%sin colocar la ficha.
dfs(Conteo , Resultado , Historia , [Movimiento|Movimientos] , Ncolocados ,O , Eliminados):-
	restan(Movimiento , R),
	Nop is Eliminados + 1,
	P is R + Ncolocados - Nop,
	P >= O -1 ,
	dfs(Conteo, Resultado , Historia ,  Movimientos , Ncolocados , O , Nop).

%calcula cuantas posiciones restan
restan(k(X , Y) , R) :- boardSize(N) ,  T is N * N , F is (X -1) * N , C is Y - 1 , R is T - (F + C).

%genera una solucion optima (ver como eliminar esto).
optima(K , 2 , 4).

optima(k(N , N) , N  , 0) :- N=\=2 , \+ even(k(N , N)).
optima(k(N , N) , N  , 1) :- N=\=2 , even(k(N , N )).
optima(k(X,Y) , N  , S) :- N=\=2  , even(k(X,Y)), siguiente(k(X,Y) , N , K1) , optima(K1 , N , S1) , S is S1 + 1.
optima(k(X,Y) , N  , S) :- N=\=2 ,  \+ even(k(X,Y)) , siguiente(k(X,Y) , N , K1) , optima(K1 , N , S).

even(k(X , Y)) :- 
	R is (X + Y) mod 2 , R = 0.

%Tama;o de tablero , Tama;o optimo de respuesta , Solucion. 
arre(T , N , L) :- 
	retractall(boardSize(_)),
	asserta((boardSize(T))),
	optima(k(1,1) , T , O) , ! ,
	generarK(k(1,1) , T , Ks),
	dfs(N , L , [] , Ks , 0 , O , 0).


inbounds(N , k(X , Y)) :- 0 < X , X =< N , 0 < Y , Y =< N.

printVseparator(0) :- print('+\n').

printVseparator(N) :- N > 0 , print('+-') , N1 is N - 1 , printVseparator(N1) , ! .

printRow(N , F , L):-
	F =< N,
	printCell(F , 1 , L , N), 
	F1 is F + 1, 
	printRow(N , F1 , L) , !.

printRow(N , F , L):-
	F > N.

printCell(F , C , L , N):-
	C =< N,
	member(k(F , C) , L) , !, 
	print('|K'),
	C1 is C + 1,
	printCell(F , C1 , L , N) ,! .

printCell(F , C , L , N):-
	C =< N,
	\+ member(k(F , C) , L) , !, 
	print('| '),
	C1 is C + 1,
	printCell(F , C1 , L , N) ,! .

printCell(_ , C ,  _ , N ):-
	C > N,
	print('|\n').

caballito(N , L) :-
	forall(member(K , L) , inbounds(N, K)),
	printVseparator(N) ,
	printRow(N , 1 , L),
	printVseparator(N) .