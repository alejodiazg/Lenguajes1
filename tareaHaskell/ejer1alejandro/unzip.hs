unzipR :: [(a,b)] -> ([a], [b])
unzipR []           = ([] , [])
unzipR ((a , b):xs) = (a : fst f , b : snd f)
	where
	   f = unzipR xs


unzipF :: [(a,b)] -> ([a], [b])
unzipF xs = foldr f ([] , []) xs
    where
   	   f (a , b) ~(as , bs) = (a:as , b:bs)

unzipM :: [(a,b)] -> ([a], [b])
unzipM xs = (map fst xs , map snd xs)

unzipL :: [(a,b)] -> ([a], [b])
unzipL xs = ([a | (a , _) <- xs] , [b | (_ , b) <- xs])