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

bindir     = "/home/carlos/Google Drive/Yachay/Semestre 7/Programacion Funcional/Webpage project/Webpage/.stack-work/install/x86_64-linux/lts-6.35/7.10.3/bin"
libdir     = "/home/carlos/Google Drive/Yachay/Semestre 7/Programacion Funcional/Webpage project/Webpage/.stack-work/install/x86_64-linux/lts-6.35/7.10.3/lib/x86_64-linux-ghc-7.10.3/Webpage-0.0.1-9OdnS7j0qDPFpdOQWYXWnX"
datadir    = "/home/carlos/Google Drive/Yachay/Semestre 7/Programacion Funcional/Webpage project/Webpage/.stack-work/install/x86_64-linux/lts-6.35/7.10.3/share/x86_64-linux-ghc-7.10.3/Webpage-0.0.1"
libexecdir = "/home/carlos/Google Drive/Yachay/Semestre 7/Programacion Funcional/Webpage project/Webpage/.stack-work/install/x86_64-linux/lts-6.35/7.10.3/libexec"
sysconfdir = "/home/carlos/Google Drive/Yachay/Semestre 7/Programacion Funcional/Webpage project/Webpage/.stack-work/install/x86_64-linux/lts-6.35/7.10.3/etc"

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
