data SuffixTree = Leaf Int
                | Node [(String,SuffixTree)]
                deriving (Eq,Ord,Show)

isPrefix :: String -> String -> Bool
isPrefix [] _           = True
isPrefix _ []           = False
isPrefix (x:xs) (y:ys)  = x == y && isPrefix xs ys

removePrefix :: String -> String -> String
removePrefix [] ys = ys
removePrefix (x:xs) (y:ys)
  | x == y = removePrefix xs ys
removePrefix _ ys = ys

suffixes :: [a] -> [[a]]
suffixes [] = []
suffixes xs = xs :  suffixes (tail xs)

isSubstring :: String -> String -> Bool
isSubstring xs ys = foldr (f xs) False (suffixes ys)
  where
    f as bs = (||) (isPrefix as bs)

