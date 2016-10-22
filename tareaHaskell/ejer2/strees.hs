data SuffixTree = Leaf Int
                | Node [(String,SuffixTree)]
                deriving (Eq,Ord,Show)

t1 :: SuffixTree
t1 = Node [("banana", Leaf 0),
		("a", Node [("na", Node [("na", Leaf 1),
						("", Leaf 3)]),
				("", Leaf 5)]),
			("na", Node [("na", Leaf 2),
				("", Leaf 4)])]

isPrefix :: String -> String -> Bool
isPrefix [] _           = True
isPrefix _ []           = False
isPrefix (x:xs) (y:ys)  = x == y && isPrefix xs ys

removePrefix :: String -> String -> String
removePrefix [] ys                    = ys
removePrefix (x:xs) (y:ys)
  | x == y  && isPrefix (x:xs) (y:ys) = removePrefix xs ys
removePrefix _ ys                     = ys

suffixes :: [a] -> [[a]]
suffixes [] = []
suffixes xs = xs :  suffixes (tail xs)

isSubstring :: String -> String -> Bool
isSubstring xs ys = foldr (f xs) False (suffixes ys)
  where
    f as bs = (||) (isPrefix as bs)

findSubstrings :: String -> String -> [Int]
findSubstrings [] _  = []
findSubstrings xs ys = f xs ys 0
	where
		f _ [] _             = []
		f xs ys n
   		  | (isPrefix xs ys) = n : f xs (tail ys) (n+1)
		f xs ys n            = f xs (tail ys) (n+1)

getIndices :: SuffixTree -> [Int]
getIndices (Node ((s,t):ys)) = foldr (\x -> (++) (getIndices (snd x))) (getIndices t) ys
getIndices (Leaf n)          = [n]


findSubstrings' :: String -> SuffixTree -> [Int]
findSubstrings' s (Node ((a,t):ys))
	 | isPrefix s a             = getIndices t
	 | isPrefix a s             = findSubstrings' (removePrefix a s) t
findSubstrings' s (Node (_:ys)) = findSubstrings' s (Node ys)
findSubstrings' s _             = []

insert :: (String,Int) -> SuffixTree -> SuffixTree
insert (s,i) st = Node (f (s, i) st)
	where
		f (s , i) (Node nds)
			| (foldr (\x -> (||) (p s (fst x))) False nds)  = foldr (\x ->  (:) (g (s , i) x)) [] nds
		f (s , i) (Node nds) = (s , Leaf i) : nds

		g (s, i) ([] , Leaf n) = ("" , Leaf n)
		g (s, i) (ns , Leaf n)
		   | isPrefix ns s = (ns , Node ([(removePrefix ns s , (Leaf i)) , ("" , (Leaf n) )]) )
		g (s , i) (ns , nt)
		   | isPrefix ns s  && (ns /= []) = (ns , (insert ((removePrefix ns s) , i) nt))
		   -- | isPrefix s ns = ("hola" , nt) -- Nunca cae este caso Dejo porsia me equivoco
		g _ (ns , nt) = (ns , nt)

		p s ns =  (isPrefix ns s) && (ns /= []) -- (isPrefix s ns) ||

buildTree :: String -> SuffixTree
buildTree s = foldr (\x -> (insert (x , f x))) (Node []) (suffixes s) --como llevo un contador de en que iteracion voy ???
	where
		t = length s
		f xs = t - length xs -- no me gusta tener que hacer esto, debe haber una mejor forma

badBuildTree :: String -> SuffixTree
badBuildTree s = f s 0
	where
	   f [] n = Node [] 
	   f s n = insert (s , n) (f (tail s) (n+1))

fecha
d m a = f (fstdays a) fromEnum(m)::Int - 1
	f (x:xs) 0 = toEnum(mod (x + d - 1) 7)::DayName
	f (x:xs) n = f xs (n-1) 

t = Node([])
a = insert ("a" , 5) t
na = insert ("na" , 4) a
ana = insert ("ana" , 3) na
nana = insert ("nana" , 2) ana
anana = insert ("anana" , 1) nana
banana = insert ("banana" , 0) anana


-- Node [("banana",Leaf 0),
--	  ("na",Node [("",Leaf 4),("na",Leaf 2)]),
--	  ("a", Node [
--	  	           ("",Leaf 5),
--	  	           ("na",Node [
--	  	           	            ("",Leaf 3),
--	  	           	            ("na",Leaf 1)
--	  	           	          ]
--	  	            )
--	  	         ])
--	 ]

-- Node [("banana",Leaf 0),
--      ("na",Node [("na",Leaf 2),("",Leaf 4)]),
 --     ("a", Node [   
--      	             ("",Leaf 5)
--      	             ("na", Node [
--	      	             	       ("na",Leaf 1),
--	      	             	       ("",Leaf 3)
 --     	             			 ]
 --     	              ),
 --     	             
 --     	         ])
 --    ]