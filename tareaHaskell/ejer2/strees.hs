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

--f :: String -> String -> Int -> [Int]
--f _ [] _ = []
--f xs ys n
--   | (isPrefix xs ys) = n : f xs (tail ys) (n+1)
--f xs ys n = f xs (tail ys) (n+1)

getIndices :: SuffixTree -> [Int]
getIndices (Leaf n) = [n]
getIndices (Node ((s,t):ys)) 
   | ys == [] = getIndices(t)
getIndices (Node ((s,t):ys)) = getIndices(t) ++ getIndices(Node ys)