module Main where

import System.Environment (getArgs)
import System.Directory (doesDirectoryExist, listDirectory)
import System.FilePath ((</>), takeExtension)
import Control.Monad (filterM)

-- Função principal que recebe o caminho de um diretório
main :: IO ()
main = do
    args <- getArgs
    case args of
        [dir] -> do
            exists <- doesDirectoryExist dir
            if exists
                then do
                    pythonFiles <- findPythonFiles dir
                    putStrLn "Arquivos Python encontrados:\n"
                    mapM_ putStrLn pythonFiles
                else putStrLn "O diretório informado não existe."
        _ -> putStrLn "Informe o caminho para o diretório."

-- Função que encontra os arquivos Python em um diretório
findPythonFiles :: FilePath -> IO [FilePath]
findPythonFiles path = do
    contents <- listDirectory path
    let paths = map (path </>) contents

    dirs <- filterM doesDirectoryExist paths
    files <- filterM (\p -> return $ takeExtension p == ".py") paths
    nestedFiles <- mapM findPythonFiles dirs

    return $ files ++ concat nestedFiles
