-----------------------------------------------------------------------------
--
-- Module      :  MainGUI
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

module MainGUI where
import Data.List
import Database.HDBC
import Database.HDBC.Sqlite3
import DataBaseLocals
import Graphics.UI.Gtk

-- Creating a window with buttons
createWindow :: IO()
createWindow = do
  -- Initializing the GUI
  initGUI
  --Creating the window
  window  <- windowNew
  -- Setting the title and dimensions of the window
  set window [windowTitle := "URCUQUI LOCALS", containerBorderWidth := 10,
              windowDefaultWidth := 400, windowDefaultHeight := 300]

  -- Creating a table
  table   <- tableNew 6 2 True
  -- Adding the table to the window
  containerAdd window table

  -- Exporting an image
  path <- imageNewFromFile "logo.png"
  -- Adding the image to the table
  tableAttachDefaults table path 0 2 0 3

  -- Creating a button
  let restaurante = "restaurante"
  button1 <- buttonNew
  -- Setting an action to do when the button is clicked
  onClicked button1 (windowSwitch restaurante)
  -- Adding the button to the table
  tableAttachDefaults table button1 0 1 3 4

  -- Creating a box
  box <- labelBox "restaurante.jpg" "Restaurantes"
  -- Adding the box to a button
  containerAdd button1 box

  let tienda = "tienda"
  button2 <- buttonNew
  -- Setting an action to do when the button is clicked
  onClicked button2 (windowSwitch tienda)
  -- Adding the button to the table
  tableAttachDefaults table button2 1 2 3 4

  -- Creating a box
  box <- labelBox "tienda.png" "Tiendas"
  -- Adding the box to a button
  containerAdd button2 box

  let mecanica = "mecanica"
  button3 <- buttonNew
  -- Setting an action to do when the button is clicked
  onClicked button3 (windowSwitch mecanica)
  -- Adding the button to the table
  tableAttachDefaults table button3 0 1 4 5

  -- Creating a box
  box <- labelBox "mecanica.png" "Mecanicas"
  -- Adding the box to a button
  containerAdd button3 box

  let otros = "otro"
  button4 <- buttonNew
  -- Setting an action to do when the button is clicked
  onClicked button4 (windowSwitch otros)
  -- Adding the button to the table
  tableAttachDefaults table button4 1 2 4 5

  -- Creating a box
  box <- labelBox "otros.png" "Otros"
  -- Adding the box to a button
  containerAdd button4 box

  button5 <- buttonNewWithLabel "Quit"
  -- Setting an action to do when the button is clicked
  onClicked button5 mainQuit
  -- Adding the button to the table
  tableAttachDefaults table button5 0 2 5 6
  -- Exit the main event
  onDestroy window mainQuit
  -- Sowing the window
  widgetShowAll window
  mainGUI

-- Show another window with different structure taking a string that represents
-- the type of Local to be consulted in the DB
windowSwitch :: String -> IO()
windowSwitch s = do
  -- Initialize the GUI
  initGUI
  -- Create a new window
  window2  <- windowNew
  -- Setting the title and dimensions of the window
  set window2 [windowTitle := "LOCALS", containerBorderWidth := 2,
                windowDefaultWidth :=500, windowDefaultHeight := 400]

  -- Creating a new box
  mb <- vBoxNew False 0
  -- Adding the box to the window
  containerAdd window2 mb

  -- Crating a scrolled window
  scrwin <- scrolledWindowNew Nothing Nothing
  -- Adding the scrolled window to the box
  boxPackStart mb scrwin PackGrow 0

  -- Making a quary with the sting provided
  dat <- consultarLocalsDBTypes (consultaTypes s)
  -- Getting the number of elements obtained in the query
  let lendat = length dat

  -- Creating a new table
  table <- tableNew lendat 4 True

  -- Adding the table to the scrolled window
  scrolledWindowAddWithViewport scrwin table

  -- Creating a text buffer to be printed in a text view
  textBuf <- textBufferNew Nothing
  textBufferSetText textBuf ("Bienvenido a la Base de Datos de los \n\
                              \locales de Urcuqui. Pulse en un local \n\
                              \para obtener mas informacion.")

  -- Creating a list of buttons
  buttonlist <- sequence (map labelButton $ zip dat (replicate lendat textBuf))
  -- Setting the place of the buttons in the list
  let places = cross [0..lendat] [0]
  -- Putting the buttons of the list in the table using the positions obtained
  -- in places
  sequence_ (zipWith (attachButton table) buttonlist places)

  -- Creating a new textView with a buffer
  info <- textViewNewWithBuffer textBuf
  -- Adding the textview to the table in a position
  tableAttachDefaults table info 1 4 0 lendat

  -- Showing the new window
  widgetShowAll window2

-- Function that takes a string and a textBuffer, and sets the
-- textBuffer with the information obtained with the query made using the string
buttonSwitch :: String -> TextBuffer -> IO ()
buttonSwitch s textBuf = do
            let consulta = consultaNames s
            value <- consultarLocal consulta
            textBufferSetText textBuf value

-- Function that creates a new labelButton and sets an action for it.
labelButton :: (String,TextBuffer) -> IO Button
labelButton (n,textBuf) = do
        button <- buttonNewWithLabel (n)
        onClicked button (buttonSwitch n textBuf)
        return button

-- Function that takes two list of integers and return a list of duplas in order
-- to determine the positions of some buttons
cross :: [Int] -> [Int] -> [(Int,Int)]
cross row col = do
        x <- row
        y <- col
        return (x,y)

-- Function that puts a button in a table in the position stablished in a dupla
-- received as argument
attachButton :: Table -> Button -> (Int,Int) -> IO ()
attachButton ta bu (x,y) =
              tableAttachDefaults ta bu y (y+1) x (x+1)

-- Function that creates a box with an image specified in FilePath and a label
-- specified in a String
labelBox :: FilePath -> String -> IO HBox
labelBox fn txt = do
  box   <- hBoxNew False 0
  set box [containerBorderWidth := 2]
  image <- imageNewFromFile fn
  label <- labelNew (Just txt)
  boxPackStart box image PackNatural 0
  boxPackStart box label PackGrow 0
  return box



