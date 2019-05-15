-----------------------------------------------------------------------------
--
-- Module      :  Functions
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Functions where
import DataTypes
import DataBaseLocals
import Database.HDBC
import Database.HDBC.Sqlite3

-- HDBC provides an abstraction layer between Haskell programs
-- and SQL relational databases.

--This is the Sqlite v3 driver for HDBC, the generic database
-- access system for Haskell

-- Geographical Position
-- Here GeographicalPosition is a tripla, where (Latitute,Longitude,Number)
getNumberFromGeographicalPosition :: GeographicalPosition -> Int
getNumberFromGeographicalPosition (_,_,c) = c

getLatitude :: GeographicalPosition -> String
getLatitude (a,_,_) = a

getLongitude :: GeographicalPosition -> String
getLongitude (_,b,_) = b

-- Address
getPrincipalStreet :: Address -> String
getPrincipalStreet (a,_,_,_) = a

getSecundaryStreet :: Address -> String
getSecundaryStreet (_,b,_,_) = b

getNumber :: Address -> Int
getNumber (_,_,c,_) = c

getRUCFromAddress :: Address -> Int
getRUCFromAddress (_,_,_,d) = d

--
getGeographicalPosition :: Address -> IO [[SqlValue]]
getGeographicalPosition (_,_,a,_) = do
                                geoPos <- consultarLocalsDB("SELECT * \
                                                            \FROM GeographicalPosition \
                                                            \WHERE Number ='" ++ (show a) ++ "'")
                                return geoPos

-- Owner
getCedulaFromOwner :: Owner -> String
getCedulaFromOwner (a,_,_,_) = a

getFirstName :: Owner -> String
getFirstName (_,b,_,_) = b

getLastName :: Owner -> String
getLastName (_,_,c,_) = c

getElectronicDevice :: Owner -> Bool
getElectronicDevice (_,_,_,d) = d

-- Local_has_Owner
getRUC :: Local_has_Owner -> Int
getRUC (a,_) = a

getCedula :: Local_has_Owner -> String
getCedula (_,b) = b

getOwner :: Local_has_Owner -> IO [[SqlValue]]
getOwner (_,a) = do
                                owner <- consultarLocalsDB("SELECT * \
                                                            \FROM Owner \
                                                            \WHERE Cedula ='" ++ a ++ "'")
                                return owner

-- Local
getRUCFromLocal :: Local -> Int
getRUCFromLocal (a,_,_,_,_,_,_) = a

getLocalName :: Local -> String
getLocalName (_,b,_,_,_,_,_) = b

getPhone :: Local -> String
getPhone (_,_,d,_,_,_,_) = d

getType :: Local -> String
getType (_,_,_,e,_,_,_) = e

getSocialNetwork :: Local -> String
getSocialNetwork (_,_,_,_,f,_,_) = f

getInternetAccess :: Local -> Bool
getInternetAccess (_,_,_,_,_,g,_) = g

getWebIDFromLocal:: Local -> Int
getWebIDFromLocal (_,_,_,_,_,_,h) = h

getWebPage :: Local -> IO [[SqlValue]]
getWebPage (_,_,_,_,_,_,a) = do
                                webPage <- consultarLocalsDB("SELECT * \
                                                            \FROM Owner \
                                                            \WHERE WebID ='" ++ (show a) ++ "'")
                                return webPage

getAddress :: Local -> IO [[SqlValue]]
getAddress (a,_,_,_,_,_,_) = do
                                address <- consultarLocalsDB("SELECT * \
                                                            \FROM Address \
                                                            \WHERE RUC ='" ++ (show a) ++ "'")
                                return address

getLocal_has_Owner :: Local -> IO [[SqlValue]]
getLocal_has_Owner (a,_,_,_,_,_,_) = do
                                owner <- consultarLocalsDB("SELECT * \
                                                            \FROM Owner \
                                                            \WHERE RUC ='" ++ (show a) ++ "'")
                                return owner

--Webpage
getWebID:: WebPage -> Int
getWebID (a,_,_) = a

getURL:: WebPage -> String
getURL (_,b,_) = b

getSupplier:: WebPage -> String
getSupplier (_,_,c) = c

















