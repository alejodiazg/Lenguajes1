type Height = Int
type Width  = Int

data Picture = Picture {
				height :: Height,
				width  :: Width,
				pixels :: [[Char]]
			} deriving (Show)


pixel :: Char -> Picture
pixel c = (Picture 1 1 [[c]])

above :: Picture -> Picture -> Picture
above p0 p1
   | width p0 == width p1 = (Picture (height p0 + height p1) (width p0) f)
       where
       	f = foldr (:) (pixels p1) (pixels p0)
above _ _ = error ("cant above different widths")

beside :: Picture -> Picture -> Picture
beside p0 p1
   | height p0 == height p1 = (Picture (height p0) (width p0 + width p1) f)
      where
     	  f = zipWith (++) (pixels p0) (pixels p1)
beside _ _ = error ("cant beside different heights")

--BETTER!!!
beside2 :: Picture -> Picture -> Picture
beside2 p0 p1
   | height p0 == height p1 = (Picture (height p0) (width p0 + width p1) (f (pixels p0) (pixels p1)))
     where
        f (x:xs) (y:ys) = foldr (:) y x : f xs ys
        f _ [] = [] 
beside2 _ _ = error ("cant beside different heights")

toString :: Picture -> String
toString = concat . (map (\x -> (foldr (:) ['\n'] x ))) . pixels

a = Picture 1 1 [['a']]
b = Picture 1 1 [['b']]
ab = above a b

