:- dynamic([bestPizza/2]).
:- initialization(retractall(bestPizza(_,_))).

/*Obtiene el corte de mondrian con menor valor posible*/
mincuts(N , Min , How):-
	retractall(bestPizza(_,_)),
	\+ mincutsHelper(N),
	bestPizza(How , Min) ,
	\+ (bestPizza(_ , M1) , Min > M1) , !.

/*helper para mincuts, llama al predicado para generar las soluciones*/
mincutsHelper(N):-
	getBetter([slice(0 , 0 , N , N )] , How) , !.

/*Obtiene mejores divisiones de la pizza*/
getBetter(Slice , BetterSlice):-
	subPizza(Slice , PosibleBetter),
	%checkBetter(Slice , PosibleBetter , BetterSlice) , !.
	pizzaMondrian(Slice , M),
	pizzaMondrian(PosibleBetter , M1),
	M1 < M,
	asserta(bestPizza(PosibleBetter , M1)),
	getBetter(PosibleBetter , BetterSlice).


/*Por backtraking genera todas las formas de cortar una pizza */
subPizza(Slices , SubSlices):-
	member(Slice , Slices),
	delete(Slices , Slice , NSlices),
	cutSlice(Slice , NewSlices),
	append(NSlices, NewSlices , SubSlices),
	validPizza(SubSlices).



%genera el arreglo de N a M
genfrom(N , M , L) :- genfrom(N, M, [] , L).
genfrom(N , N , A , R) :- N >= 0 , R = [N | A]. 
genfrom(N , M , A , R) :- M > N , N >= 0 , M1 is M -1 , genfrom(N , M1 , [M| A] , R).

%genera la lista posible de cortes verificando que no existan cortes con menos de una unidad de distancia
genCutPos(N , M , L):- N1 is N + 1 ,  M1 is M - 1 , M1 > N1, genfrom(N1 , M1 , L).

%genera los cortes horizontales
genHcuts(slice(Xini , Yini , Xfin , Yfin) , Cuts):-
	genCutPos(Xini , Xfin , L) , !,
	member(X , L),
	Cuts = [slice(Xini , Yini , X , Yfin) , slice(X , Yini , Xfin , Yfin)].

%genera los cortes verticales
genVcuts(slice(Xini , Yini , Xfin , Yfin) , Cuts):-
	genCutPos(Yini , Yfin, L) , !,
	member(Y , L),
	Cuts = [slice(Xini , Yini ,Xfin , Y) , slice(Xini, Y , Xfin , Yfin)].

%Prueba tanto cortando horizontalmente como verticalmente el slice dado
cutSlice(Slice , Slices) :- genHcuts(Slice , Slices).
cutSlice(Slice , Slices) :- genVcuts(Slice , Slices).

mondrianValue(Slice , Slice  , V):-
	sliceArea(Slice , V).

/*Calcula el valor de mondrian entre dos slices*/
mondrianValue(Slice , Slice1 , V) :- 
	sliceArea(Slice , S) , 
	sliceArea(Slice1 , S1) , 
	S > S1,
	V is S - S1. 

/*Calcula el area de un slice de pizza */
sliceArea(slice(Xini , Yini , Xfin, Yfin) , S):-
	X is Xfin - Xini,
	Y is Yfin - Yini,
	S is X * Y.

/* Calcula el valor mondrian de la pizza */
pizzaMondrian(Slices , V):- 
	minSlice(Slices , Ss),
	maxSlice(Slices , Ls),
	mondrianValue(Ls , Ss , V) , !.

/* Gets the slice with the smaller area
*/
minSlice([S|Sls] , Min):-
	minSlice(Sls , S , Min).

minSlice([] , Min , Min).

minSlice([S|Sls] , Sm , Min) :- 
	sliceArea(S , A1) , 
	sliceArea(Sm , A2) , 
	A1 < A2 , 
	minSlice(Sls , S , Min).

minSlice([S|Sls] , Sm , Min) :- 
	sliceArea(S , A1) , 
	sliceArea(Sm , A2) ,
	A1 >= A2,
	minSlice(Sls , Sm , Min).

/*Gets the slice with the largest area
*/
maxSlice([S|Sls] , Max):-
	maxSlice(Sls , S , Max).

maxSlice([] , Max , Max).

maxSlice([S|Sls] , Sm , Max):-
	sliceArea(S , A1),
	sliceArea(Sm , A2),
	A1 > A2,
	maxSlice(Sls , S , Max).

maxSlice([S|Sls] , Sm , Max):-
	sliceArea(S , A1),
	sliceArea(Sm , A2),
	A2 >= A1 ,
	maxSlice(Sls , Sm , Max).

/*Valid cuts
 *Debe devolver si los cortes son validos
*/
validPizza(Slices) :-
	forall(member(Sl1 , Slices) , \+ (member(Sl2 , Slices) , equivalentSlice(Sl1 , Sl2) , Sl1 \= Sl2 )) .


/*Equivalent slice
 *Indica si dos slice son equivalentes
*/
equivalentSlice(slice(X1ini , Y1ini , X1fin , Y1fin) , slice(X2ini , Y2ini , X2fin , Y2fin)):-
	X1 is X1fin - X1ini,
	Y1 is Y1fin - Y1ini,
	X2 is X2fin - X2ini,
	Y2 is Y2fin - Y2ini,
	((X1 = X2 , Y1 = Y2) ; (X1 = Y2 , Y1 = X2)).  

