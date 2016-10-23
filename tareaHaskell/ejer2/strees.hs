data SuffixTree = Leaf Int
                | Node [(String,SuffixTree)]
                deriving (Eq,Ord,Show)

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
suffixes xs = xs : suffixes (tail xs)

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
		f (s , i) (Leaf n) = [(s , Leaf i) , ("" , Leaf n)]
		g (s, i) (ns , nt)
		    | ns /= []  &&  isPrefix ns s = (ns , insert (removePrefix ns s, i) nt)
		    | ns /= []  &&  isPrefix [head ns] s  = ([head ns] , insert (tail s , i) nt)
			| otherwise = (ns , nt)
		p s ns =(ns /= []) && (( ([head ns] /= [] ) && (isPrefix [head ns] s)) )


buildTree :: String -> SuffixTree
buildTree s = foldr (\x -> (insert (x , f x))) (Node []) (suffixes s)
	where
		t = length s
		f xs = t - length xs

longestRepeatedSubstring :: SuffixTree -> [String]
longestRepeatedSubstring sf = unique $ longest 0 (filter (\x-> count x r > 1) r) [] 
	where
		r = lrs sf
		join s xs     = concat $ foldr (\x-> (:) (foldr (\y-> (:) (x++y) ) [] xs )) [] (suffixes s)
		lrs (Node xs) = l 
			where 
				l = foldr (\x -> (++) ((fst x) : (join (fst x) (lrs (snd x) ) ) )) [] xs
		lrs (Leaf n)  = []
		count [] _ = 0
		count _  [] = 0
		count x (y:ys) = if x == y then 1 + (count x ys) else 0 + (count x ys)
		unique xs = [x | (x,y) <- zip xs [0..], x `notElem` (take y xs)]

		longest  _ [] ys = ys
		longest n (x:xs) ys
			| length x > n = longest (length x) xs [x]
			| length x == n =  longest n xs (x:ys)
			| otherwise = longest n xs ys     

--t = Node([])
--a = insert ("a" , 5) t
--na = insert ("na" , 4) a
--ana = insert ("ana" , 3) na
--nana = insert ("nana" , 2) ana
--anana = insert ("anana" , 1) nana
--banana = insert ("banana" , 0) anana