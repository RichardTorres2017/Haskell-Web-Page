module Paths_Webpage (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,0,1] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/root/.cabal/bin"
libdir     = "/root/.cabal/lib/x86_64-linux-ghc-7.10.3/Webpage-0.0.1-HyLD0sU4DZAGnf7mkUfccH"
datadir    = "/root/.cabal/share/x86_64-linux-ghc-7.10.3/Webpage-0.0.1"
libexecdir = "/root/.cabal/libexec"
sysconfdir = "/root/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Webpage_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Webpage_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Webpage_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Webpage_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Webpage_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
