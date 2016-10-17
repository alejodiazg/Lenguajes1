--PRIMERA PARTE
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

stack :: [Picture] -> Picture
stack = foldr1 above

spread :: [Picture] -> Picture
spread = foldr1 beside2

row :: String -> Picture
row = spread . map pixel

--No me gusta esta funcion!!!
blank :: (Height,Width) -> Picture
blank = f --estoy haciendo trampa
   where f (h , w) = stack (map (\x -> spread x) (replicate  h (replicate w (Picture 1 1 [[' ']]))))

stackWith :: Height -> [Picture] -> Picture
stackWith h = foldr1 (\x-> above(above x (blank (h , width x))))
  where blanks = blank (h , 1)

spreadWith :: Width -> [Picture] -> Picture
spreadWith w = foldr1 (\x-> beside2 (beside2 x (blank (height x , w))))

tile :: [[Picture]] -> Picture
tile = stack . map (\x -> spread x)

tileWith :: (Height, Width) -> [[Picture]] -> Picture
tileWith (h , w) = f  . map (spreadWith w)
  where 
    f = stackWith h

--Segunda Parte


--PARA PROBAR
a = Picture 1 1 [['a']]
b = Picture 1 1 [['b']]
ab = above a b
tiles = tile ([[b , a , b , a] ,[a , b , a , b] , [b , a , b , a] , [a , b , a , b]])
moretilesH = spreadWith 4 [tiles , tiles , tiles , tiles]
moretilesV = stackWith 4 [tiles , tiles , tiles , tiles]