attack(X, Y) :- 
	buildmoves(X , M),
	member(Y ,  M), !.

notSafe(X , Y) :-member(T , X) , member(T , Y) , !.

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

gen(N,L) :- gen(N,[],L).
gen(0,A,A).
gen(N,A,R) :- N > 0, N1 is N-1, gen(N1,[N|A],R).

%Generates an array with numbers from N to M
%both should be greater than 0  and M greater or equal than N. 
genfrom(N , M , L) :- genfrom(N, M, [] , L).
genfrom(N , N , A , R) :- N > 0 , R = [N | A]. 
genfrom(N , M , A , R) :- M > N , N > 0 , M1 is M -1 , genfrom(N , M1 , [M| A] , R).

primera(N , K) :- gen(N , L) , member(X , L) , gen(N, M) , member(Y , M) , K = k(X , Y).

%obtains if exists the next position in the board
siguiente(k(X , Y) , N , K) :- Y = N , Y1 is  1 , X < N , X1 is X + 1, K = k(X1 , Y1).
siguiente(k(X , Y) , N , K) :- Y < N , Y1 is Y+1 , K = k(X , Y1).

%No se si va a ser util
resto(k(X , Y) ,  N , A):-
	X1 is X + 1,
	genfrom(X1 , N  , A1),
	crearK(X1 , A1 , A).

crearK(X , [] , []).
crearK(X , [Y | Ys] , A) :- crearK(X , Ys , A1) , A = [k(X,Y)|A1].

%no se si va a ser util
crear(N , T) :- primera(N, K) , print(K) ,resto(K , N , T) , print(T).

%probar ya me esta generando todas las posibilidades de tablero
%dada todas estas posibilidades necesito guardar las mejores soluciones
probar(k(N , N) , N , [k(N,N)] , 1 , _).
probar(k(N , N) , N , [] , 0 , _).
probar(k(X , Y) , N, T , S , O):-
		siguiente(k(X,Y) , N , P) , 
		probar(P , N , T1 , S1) , 
		colide(T1 , k(X,Y) , T , S2) , 
		S is S2 + S1.


%probar2(k(N , N) , N , T , [k(N,N)|T] , 1 , _ , _).
%probar2(k(N , N) , N , T , T , 0 , _ , _).
probar2(k(N , N) , N , T , L , S , _ , _):- colide(T , k(N,N), L , S).


probar2(k(X , Y)  , N , T , T , O , O , O):- !.
% k(X,Y): elemento a probar
% N : tama;o del tablero
%T :tablero que llevo
%Tq : tablero respuesta
%S: tama;o respuesta
%Sl : tama;o que llevo
%O : objetivo
probar2(k(X , Y) , N , T , Tq, S , Sl , O) :-
		%print('k es : '),
		%print(k(X, Y)),
		%print(' llevo '),
		%print(Sl),
		%print('\n'),
		siguiente(k(X, Y) , N ,K1),
		suficientes(k(X,Y) , N , Sl , O),
		colide(T , k(X,Y) , Tva , S1) ,
		Sl1 is Sl + S1,
		probar2(K1 , N , Tva  , Tq , S2 , Sl1 , O ),
		S is S1 + S2.

probar2(k(X , Y)  , N , T , T , O , O , O):- !.

colide(T1 , K , T , 1):- buildmoves(K , M) ,\+ notSafe(M , T1) , T = [K|T1].
colide(T1 , K , T1, 0):- buildmoves(K , M) ,\+ notSafe(M , T1).
colide(T1, K, T1 , 0):-buildmoves(K , M) , notSafe(M , T1).

%esta version crea muchas llamadas recursivas para verificar si existe alguna solucion de mayor tama;o
%arre(T , N , L) :- probar(k(1,1), T , L , N) , \+ (probar(k(1,1) , T , _ , S1) , ! , S1 > N) .

%arre viejo 
%arre(T , N , L) :-optima(k(1,1) , T , S) , ! ,  probar(k(1,1), T , L , N)  , S = N.
arre(T , N , L) :-optima(k(1,1) , T , O), ! ,  probar2(k(1,1) , T , [] , L, N , 0 , O) , N = O.

optima(K , 2 , 4).

optima(k(N , N) , N  , 0) :- N=\=2 , \+ even(k(N , N)).
optima(k(N , N) , N  , 1) :- N=\=2 , even(k(N , N )).
optima(k(X,Y) , N  , S) :- N=\=2  , even(k(X,Y)), siguiente(k(X,Y) , N , K1) , optima(K1 , N , S1) , S is S1 + 1.
optima(k(X,Y) , N  , S) :- N=\=2 ,  \+ even(k(X,Y)) , siguiente(k(X,Y) , N , K1) , optima(K1 , N , S).

%Version que devuelve el arreglo optimo
%optima(k(N , N) , N , [] , 0) :- N=\=2 , \+ even(k(N , N)).
%optima(k(N , N) , N , [k(N,N)] , 1) :- N=\=2 , even(k(N , N )).
%optima(k(X,Y) , N , [k(X,Y)|L] , S) :- N=\=2  , even(k(X,Y)), siguiente(k(X,Y) , N , K1) , optima(K1 , N , L , S1) , S is S1 + 1.
%optima(k(X,Y) , N , L , S) :- N=\=2 ,  \+ even(k(X,Y)) , siguiente(k(X,Y) , N , K1) , optima(K1 , N , L , S).

restan(k(X , Y) , N , R) :- T is N * N , F is (X -1) * N , C is Y - 1 , R is T - (F + C).

%k(x,y) , N tama;o , L cantidad de caballos colocados , O cantidad optima
suficientes(K , N , L ,O ):-
		restan(K , N , R),
		P is R + L,
		%print('Posibles son '),
		%print(P),
		%print('\n'),
		P >= O.
		%print('son suficientes para seguir \n').


even(k(X , Y)) :- R is (X + Y) mod 2 , R is 0.