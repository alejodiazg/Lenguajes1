import System.IO

loadEvents :: FilePath -> IO String
loadEvents pathName = do
	content <- readFile "/home/vanessa/Desktop/hola.txt"
	return $ read content

main = do
	contents <- readFile "/home/vanessa/Desktop/hola.txt"
	putStr contents

