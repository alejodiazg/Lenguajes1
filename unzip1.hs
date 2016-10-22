unzipR :: [(a,b)] -> ([a], [b])
unzipR [] = ([], [])
unzipR ((a,b) : xs) = (a:(fst unzipR') , b:(snd unzipR'))
	where unzipR' = unzipR xs

unzipM :: [(a,b)] -> ([a], [b])
unzipM xs = (map fst xs, map snd xs)

unzipF :: [(a,b)] -> ([a], [b])
unzipF xs = foldr f b xs
		where
			f (a,b) (as,bs) = (a:as, b:bs)
			b               = ([], [])

unzipF' :: [(a,b)] -> ([a], [b])
unzipF' xs = foldr (\(a,b) (as,bs) -> (a:as, b:bs)) ([], []) xs

unzipL :: [(a,b)] -> ([a], [b])
unzipL xs = [(a,b) | (a,b) <- xs, (as,bs) <- xs]