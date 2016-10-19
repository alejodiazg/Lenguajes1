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
		f _ [] _= []
		f xs ys n
   		  | (isPrefix xs ys) = n : f xs (tail ys) (n+1)
		f xs ys n = f xs (tail ys) (n+1)

getIndices :: SuffixTree -> [Int]
getIndices (Node ((s,t):ys)) = foldr (\x -> (++) (getIndices (snd x))) (getIndices t) ys
getIndices (Leaf n) = [n]


--findSubstrings' s st = f s st
--	where f ss (Node ((s,t):ys)) =

findSubstrings' :: String -> SuffixTree -> [Int]
test s (Node ((a,t):ys))
	| isPrefix s a = getIndices t
	| isPrefix a s = test (removePrefix a s) t
test s (Node (_:ys)) = test s (Node ys)
test s _ = []