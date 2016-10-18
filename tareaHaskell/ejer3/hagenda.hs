--PRIMERA PARTE
type Height = Int
type Width  = Int

data Picture = Picture {
				height :: Height,
				width  :: Width,
				pixels :: [[Char]]
			} deriving (Show)

type Day = Int -- Suponga que está entre 1 y 31
type Year = Int -- Suponga que es positivo
data Month = Enero
  | Febrero
  | Marzo
  | Abril
  | Mayo
  | Junio
  | Julio
  | Agosto
  | Septiembre
  | Octubre
  | Noviembre
  | Diciembre
  deriving (Show,Eq,Ord,Enum)

data DayName = Domingo
  | Lunes
  | Martes
  | Miercoles
  | Jueves
  | Viernes
  | Sabado
  deriving (Show,Eq,Ord,Enum)

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


leap:: Year -> Bool --REVISAR
leap y = ((mod y 4 == 0) && (mod y 100 /= 0)) || ((mod y 4 == 0) && (mod y 100 == 0) && (mod y 400 == 0))

mlenghts :: Year -> [Day]
mlenghts y = [31 , f , 31 , 30 , 31 , 30 , 31 , 31 , 30 , 31 , 30 , 31]
  where 
    f = if leap y
      then 29
      else 28

jan1 :: Year -> DayName
jan1 y = toEnum  d::DayName --(mod (y*365 + ( div (y-1) 4)) 7)::DayName
  where
    a = div (14 - 1) 12
    year = y - a
    m = 1 + 12*a - 2
    d = mod (1 + year + div year 4 - div year 100 + div year 400 + div (31*m) 12)  7

mtotals :: Year -> [Int]
mtotals y = f (fromEnum (jan1 y)::Int) (0:mlenghts y)
  where
    f n (x:xs) = (x+n) : f (x+n) xs
    f n _ = []  

fstdays :: Year -> [DayName]
fstdays y = map (\x -> toEnum (mod x 7)::DayName) (filter (\x -> x < 360) (mtotals y)) --buscar otra forma de omitir el ultimo elemento




--PARA PROBAR
a = Picture 1 1 [['a']]
b = Picture 1 1 [['b']]
ab = above a b
tiles = tile ([[b , a , b , a] ,[a , b , a , b] , [b , a , b , a] , [a , b , a , b]])
moretilesH = spreadWith 4 [tiles , tiles , tiles , tiles]
moretilesV = stackWith 4 [tiles , tiles , tiles , tiles]