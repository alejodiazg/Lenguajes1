% A dynamic predicate for counting things.
:- dynamic([boardSize/1]).
% This is the main predicate to run.
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
deleteOne([K|Ks] , Kx , [K|Krs] , S) :-  deleteOne(Ks , Kx , Krs, S).

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
filterMoves([K|Ks] , [K|Kxs]) :- safeK(K) , ! , filterMoves(Ks , Kxs).
filterMoves([K|Ks] , Kxs) :- \+ safeK(K) , ! , filterMoves(Ks , Kxs).


%Conteo , Estado resultante, Historia , Movimientos , Objetivo 
dfs(Ncolocados , Colocados , Colocados , [] , Ncolocados , O) :-
	Ncolocados = O.

%colocando la ficha.
dfs(Conteo, Resultado ,  Historia , [Movimiento|Movimientos] , Ncolocados , O) :-
	removeFromMoves(Movimiento  , Movimientos , Posibles , Removidos),
	Ncol is Ncolocados + 1,
	restan(Movimiento , R),
	P is R + Ncol,
	P >= O,
	dfs(Conteo , Resultado , [Movimiento|Historia] , Posibles, Ncol , O).

%sin colocar la ficha.
dfs(Conteo , Resultado , Historia , [Movimiento|Movimientos] , Ncolocados ,O):-
	Ncol is (Ncolocados + 0),
	restan(Movimiento , R),
	P is R + Ncol,
	P >= O,
	dfs(Conteo, Resultado , Historia ,  Movimientos , Ncol , O).

%calcula cuantas posiciones restan
restan(k(X , Y) , R) :-boardSize(N) ,  T is N * N , F is (X -1) * N , C is Y - 1 , R is T - (F + C).

%genera una solucion optima (ver como eliminar esto).
optima(K , 2 , 4).

optima(k(N , N) , N  , 0) :- N=\=2 , \+ even(k(N , N)).
optima(k(N , N) , N  , 1) :- N=\=2 , even(k(N , N )).
optima(k(X,Y) , N  , S) :- N=\=2  , even(k(X,Y)), siguiente(k(X,Y) , N , K1) , optima(K1 , N , S1) , S is S1 + 1.
optima(k(X,Y) , N  , S) :- N=\=2 ,  \+ even(k(X,Y)) , siguiente(k(X,Y) , N , K1) , optima(K1 , N , S).

even(k(X , Y)) :- R is (X + Y) mod 2 , R = 0.

%Tama;o de tablero , Tama;o optimo de respuesta , Solucion. 
arre(T , N , L) :- 
	asserta((boardSize(T))),
	optima(k(1,1) , T , O) , ! ,
	generarK(k(1,1) , T , Ks),
	dfs(N , L , [] , Ks , 0 , O).
	