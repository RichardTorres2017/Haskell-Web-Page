-----------------------------------------------------------------------------
--
-- Module      :  DataTypes
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

module DataTypes where

type PrincipalStreet = String
type SecondaryStreet = String
type Number = Int

type Address = (PrincipalStreet, SecondaryStreet,Number,RUC)

type Latitude = String
type Longitude = String

type GeographicalPosition = (Latitude, Longitude, Number)

type LocalName = String
type Phone = String
type Type = String
type SocialNetwork = String
type InternetAccess = Bool

type Local = (RUC,LocalName,Phone,Type,SocialNetwork,InternetAccess,WebID)

type FirstName = String
type LastName = String
type ElectronicDevice = Bool
type RUC = Int
type WebID = Int
type Cedula = String

type Owner = (Cedula,FirstName, LastName, ElectronicDevice)

type URL = String
type Supplier = String

type Local_has_Owner = (RUC,Cedula)

type WebPage = (WebID,URL,Supplier)




