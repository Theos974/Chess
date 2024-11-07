--
-- PUT ANY IMPORT STATEMENTS HERE
--
import Data.Char (isAlpha,isDigit)




--
-- DO NOT MODIFY THESE TYPES
--
data Piece = Pawn | Knight | Bishop | Rook | Queen | King
  deriving (Eq,Show,Enum)

data Colour = White | Black
  deriving (Eq,Show)

data Square = Empty | Filled Colour Piece
  deriving (Eq,Show)

type Board = [[Square]]
type IndexedBoard = [(Square,(Int,Int))]

type Loc = (Int,Int)
--------------------------------

parseMove :: Board -> Colour -> String -> (Piece,[Loc],Loc,(Maybe Int,Maybe Int),Bool)
parseMove board colour moveStr = (givePiece moveStr, giveLocations board (givePiece moveStr) colour, giveDestination moveStr, giveDisambiguation moveStr, giveTaken moveStr)



givePiece :: String -> Piece
givePiece (c:_) = givePieceChar c  -- Match on the first character
givePiece _     = Pawn             -- Default to Pawn if input is empty

-- Helper function that matches a single character to a Piece
givePieceChar :: Char -> Piece
givePieceChar 'K' = King
givePieceChar 'Q' = Queen
givePieceChar 'R' = Rook
givePieceChar 'B' = Bishop
givePieceChar 'N' = Knight
givePieceChar _   = Pawn  -- Default to Pawn if no match



giveLocations:: Board -> Piece -> Colour -> [Loc]
giveLocations board piece colour = [(colIdx, rowIdx) | (rowIdx, row) <- zip [0..] board,
                                                       (colIdx, square) <- zip [0..] row,
                                                       square == Filled colour piece]


giveDestination :: String -> Loc
giveDestination str
  | length str < 2 = error "Invalid move notation"  -- Handle cases where input is too short
  | otherwise =
      let grid = drop (length str - 2) str
          colIndex = fromEnum (head grid) - fromEnum 'a'
          rowIndex = 7 - (fromEnum (last grid) - fromEnum '1')
      in (colIndex, rowIndex)




-- Helper function to convert a column letter ('a' to 'h') to an index (0 to 7)
colIndex :: Char -> Int
colIndex c = fromEnum c - fromEnum 'a'

-- Helper function to convert a row number ('1' to '8') to an index (7 to 0)
rowIndex :: Char -> Int
rowIndex r = 7 - (fromEnum r - fromEnum '1')


giveTaken :: String -> Bool
giveTaken str = 'x' `elem` str


giveDisambiguation :: String -> (Maybe Int, Maybe Int)
giveDisambiguation moveStr =
  let piece = givePiece moveStr                          -- Get the piece type
      cleanedStr = filter (/= 'x') moveStr               -- Remove 'x' for capture
      disambStr = if piece == Pawn then cleanedStr else tail cleanedStr  -- Skip piece identifier if not pawn
  in parseDisambiguation disambStr

-- Parse disambiguation based on the length of the remaining string
parseDisambiguation :: String -> (Maybe Int, Maybe Int)
parseDisambiguation str
  | length str == 2 = (Nothing, Nothing)  -- Only destination, no disambiguation
  | length str == 3 = singleDisambiguation str
  | length str == 4 = doubleDisambiguation str
  | otherwise       = (Nothing, Nothing)  -- Unexpected format

-- Handle cases where there's a single disambiguation character
singleDisambiguation :: String -> (Maybe Int, Maybe Int)
singleDisambiguation (c:dest)
  | isAlpha c = (Just (colIndex c), Nothing)  -- Column disambiguation
  | isDigit c = (Nothing, Just (rowIndex c))  -- Row disambiguation
singleDisambiguation _ = (Nothing, Nothing)

-- Handle cases where there are two disambiguation characters
doubleDisambiguation :: String -> (Maybe Int, Maybe Int)
doubleDisambiguation (c1:c2:dest)
  | isAlpha c1 && isDigit c2 = (Just (colIndex c1), Just (rowIndex c2))  -- Column then row
  | isDigit c1 && isAlpha c2 = (Just (colIndex c2), Just (rowIndex c1))  -- Row then column
doubleDisambiguation _ = (Nothing, Nothing)
