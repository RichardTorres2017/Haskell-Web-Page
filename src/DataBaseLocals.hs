-----------------------------------------------------------------------------
--
-- Module      :  DataBase
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :
-- Stability   :
-- Portability :
--
--
--
-----------------------------------------------------------------------------

module DataBaseLocals where
import Database.HDBC
import Database.HDBC.Sqlite3
import Data.List

-- Getting information about the DB
infoConexionLocalsDB :: IO()
infoConexionLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Showing information
      putStr ("Nombre del driver hdbc: " ++ (hdbcDriverName conn) ++ "\n")
      putStr ("Version del cliente usada: " ++ (hdbcClientVer conn) ++ "\n")
      putStr ("Version del DB: " ++ (dbServerVer conn) ++ "\n")

      -- Disconnecting from the DB
      disconnect conn

-- Creating the DB
crearLocalsDB :: IO()
crearLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Creating table Owner
      run conn "CREATE TABLE Owner (\
               \Cedula VARCHAR(10) PRIMARY KEY, \
               \FirstName VARCHAR(30), \
               \LastName VARCHAR(30), \
               \ElectronicDevice BOOLEAN)" []
      -- Creating table Address
      run conn "CREATE TABLE Address (\
               \Number INTEGER PRIMARY KEY, \
               \PrincipalStreet VARCHAR(30), \
               \SecundaryStreet VARCHAR(30), \
               \RUC INTEGER REFERENCES Local(RUC))" []
      -- Creating table GeographicalPosition
      run conn "CREATE TABLE GeographicalPosition (\
               \Latitud VARCHAR(20), \
               \Longitud VARCHAR(20), \
               \Number INTEGER REFERENCES Address(Number))" []
      -- Creating table WebPage
      run conn "CREATE TABLE WebPage (\
               \WebID INTEGER PRIMARY KEY, \
               \Supplier VARCHAR(30), \
               \URL VARCHAR(50))" []
      -- Creating table Local
      run conn "CREATE TABLE Local (\
               \RUC INTEGER PRIMARY KEY, \
               \LocalName VARCHAR(30), \
               \Phone VARCHAR(30), \
               \Type VARCHAR(30), \
               \SocialNetwork VARCHAR(30), \
               \InternetAccess BOOLEAN, \
               \WebID INTEGER REFERENCES WebPage(WebID))" []
      -- Creating table Local_has_Owner
      run conn "CREATE TABLE Local_has_Owner (\
               \RUC INTEGER REFERENCES Local(RUC), \
               \Cedula VARCHAR(10) REFERENCES Owner(Cedula))" []
      -- Making commit
      commit conn
      -- Disconnecting from the DB
      disconnect conn

-- Inserting information into the tables
insertarLocalsDB :: IO()
insertarLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Example of insertion
      insertaO <- prepare conn "INSERT INTO Owner VALUES (?, ?, ?, ?)"
      insertaA <- prepare conn "INSERT INTO Address VALUES (?, ?, ?, ?)"
      insertaGP <- prepare conn "INSERT INTO GeographicalPosition VALUES (?, ?, ?)"
      insertaW <- prepare conn "INSERT INTO WebPage VALUES (?, ?, ?)"
      insertaL <- prepare conn "INSERT INTO Local VALUES (?, ?, ?, ?, ?, ? ,?)"
      insertaLHO <- prepare conn "INSERT INTO Local_has_Owner VALUES (?, ?)"

      executeMany insertaO [[toSql "0367745639",
                             toSql "Francisco",
                             toSql "Torres",
                             toSql (True::Bool)]]

      executeMany insertaA [[toSql (234::Int),
                             toSql "Pedro Moncayo",
                             toSql "Guayaquil",
                             toSql (1235375940::Int)]]

      executeMany insertaGP [[toSql "78 48 6",
                             toSql "34 7 5",
                             toSql (234::Int)]]

      executeMany insertaW [[toSql (1246646::Int),
                             toSql "Google",
                             toSql "www.google.com"]]

      executeMany insertaL [[toSql (1235375940::Int),
                             toSql "Tienda de Pedro",
                             toSql "0983664765",
                             toSql "Bazar",
                             toSql "facebook",
                             toSql (True::Bool),
                             toSql (1246646::Int)]]

      executeMany insertaLHO [[toSql (1235375940::Int),
                             toSql "0367745639"]]

      -- Making commit
      commit conn
      -- Disconnecting from the DB
      disconnect conn

-- Updating information in the DB
actualizarLocalsDB :: IO ()
actualizarLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Example of the update of URl in Webpage table
      run conn "UPDATE WebPage SET URL = 'www.yahoo.com' WHERE webID = '1246646'" []

      -- Making commit
      commit conn

      -- DEsconnecting from the DB
      disconnect conn


-- Some Queries

-- Selecting some important information from the natural union of three tables
-- where the LocalName is equal to a string specified by the user
consultaNames :: String -> String
consultaNames s = "SELECT LocalName, Phone,PrincipalStreet,SecundaryStreet,FirstName,LastName,SocialNetwork \
                  \FROM Local NATURAL JOIN Address NATURAL JOIN Local_has_Owner NATURAL JOIN Owner \
                  \WHERE LocalName='" ++ s ++ "'"

-- Selecting the LocalName from the table Local, where Type is equal to a string
-- given by the user
consultaTypes :: String -> String
consultaTypes s = "SELECT LocalName \
              \FROM Local \
              \WHERE Type='" ++ s ++ "'"

-- Consult the DB
consultarLocalsDB :: String -> IO [[SqlValue]]
consultarLocalsDB consulta =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Making the query
      tuplas <- quickQuery' conn consulta []

      -- Making commit
      commit conn

      -- Desconnecting from the DB
      disconnect conn

      -- Returning the tuples
      return tuplas

-- Turning a list of String into a String
printElements :: [String] -> String
printElements [] = []
printElements (x:xs) =  x ++ "\n"++ ( printElements xs)

-- Consulting types of Locals in the DB
consultarLocalsDBTypes :: String -> IO[String]
consultarLocalsDBTypes consulta  =
      do -- Connecting to the DB
       conn <- connectSqlite3 "LocalsDB.db"

       -- Running the query and storing the results in r
       r <- quickQuery' conn consulta []

       -- Converting each row into a String
       let stringRows = map convRow r

       -- Returning a String
       return stringRows

    -- Converting a list of SqlValue into a String
    where convRow :: [SqlValue] -> String
          convRow s = fromSql (head s)

-- Consulting all information about a Local
consultarLocal :: String -> IO(String)
consultarLocal n  =
      do -- Connecting to the database
       conn <- connectSqlite3 "LocalsDB.db"

       -- Running the query and storing the results in r
       r <- quickQuery' conn n []

       -- Converting each row into a String
       let stringRows = map convRow r

       -- Returning each String
       return $ printElements stringRows

    --Turning a list of SqlVlue into a String
    where convRow :: [SqlValue] -> String
          convRow [sqlL, sqlP,sqlPS,sqlSS,sqlFN,sqlLN,sqlSN] =
              "Local Name: "++ one++"\nPhone: "++two++"\nPrincipal Street: "++three++"\nSecundary Street: "++four++"\nOwner: "++five ++ " " ++ six++"\nSocial Network: "++seven
              where one  = fromSql sqlL
                    two = fromSql sqlP
                    three = fromSql sqlPS
                    four = fromSql sqlSS
                    five = fromSql sqlFN
                    six = fromSql sqlLN
                    seven = fromSql sqlSN

-- Deleting information in the DB
eliminarLocalsDB :: IO ()
eliminarLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Deleting a tuple in the WEbPage table
      run conn "DELETE FROM Webpage WHERE WebID = ? " [toSql (123::Int)]

      -- Making commit
      commit conn

      -- Desconnecting from the DB
      disconnect conn

-- Printing information about tables in the DB
infoLocalsDB :: IO()
infoLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Getting the information
      tables <- getTables conn

      -- Showing the information
      putStr (concat (map (++"\n") tables))

      -- Desconnecting from the DB
      disconnect conn

-- Showing a table from the DB
tablaLocalsDB :: IO [[SqlValue]]
tablaLocalsDB =
    do
      -- Asking the name of the table to consult
      putStr "Name of the table: "

      -- Saving the name of the table
      nombre <- getLine

      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Making the query
      tuplas <- quickQuery' conn ("SELECT * FROM " ++ nombre) []

      -- Desconnecting from the DB
      disconnect conn

      -- Returning the tuples
      return tuplas

-- Deleting the DB
borrarLocalsDB :: IO()
borrarLocalsDB =
    do
      -- Connecting to the DB
      conn <- connectSqlite3 "LocalsDB.db"

      -- Deleting the table GeographicalPosition
      run conn "DROP TABLE GeographicalPosition" []
      -- Deleting the table Address
      run conn "DROP TABLE Address" []
      -- Deleting the table WebPage
      run conn "DROP TABLE Address" []
      -- Deleting the table Local
      run conn "DROP TABLE Local" []
      -- Deleting the table Local_has_Owner
      run conn "DROP TABLE Local_has_Owner" []
      -- Deleting the table Owner
      run conn "DROP TABLE Owner" []

      -- Making commit
      commit conn

      -- Desconnecting fromm DB
      disconnect conn




