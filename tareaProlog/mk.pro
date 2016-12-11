attack(X, Y) :- 
	buildmoves(X , M),
	member(Y ,  M), !.

notSafe(X , Y) :-member(T , X) , member(T , Y) , !.

buildmoves(k(X, Y) , [k(X,Y) , K1 , K2 , K3, K4]) :-
	leftUp(k(X, Y) , K1),
	leftDown(k(X, Y) , K2),
	upLeft(k(X, Y) , K3),
	upRight(k(X, Y) , K4).

leftUp(k(X, Y) , k(Kx , Ky)) :- Kx is X - 2 , Ky is Y - 1.
leftDown(k(X, Y) , k(Kx , Ky)) :- Kx is X - 2 , Ky is Y + 1.
upLeft(k(X, Y) , k(Kx , Ky)) :- Kx is X - 1 , Ky is Y - 2.
upRight(k(X, Y) , k(Kx , Ky)) :- Kx is X + 1 , Ky is Y - 2.

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
probar(k(N , N) , N , [k(N,N)]).
probar(k(N , N) , N , []).
probar(K, N, T):- siguiente(K , N , P) , probar(P , N , T1) , colide(T1 , K , T). %buildmoves(K , M) , member(X , M) , \+ member(X , T1), T = [K|T1].
%probar(K , N , T):- siguiente(K , N , P) , probar(P , N , T).

colide(T1 , K , T):- buildmoves(K , M) ,\+ notSafe(M , T1) , T = [K|T1].
colide(T1 , K , T1):- buildmoves(K , M) ,\+ notSafe(M , T1).
colide(T1, K, T1):-buildmoves(K , M) , notSafe(M , T1).