--
-- PUT ANY IMPORT STATEMENTS HERE
--
import Data.List (find,sort)


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
------------------------------
possMoves :: Board -> Loc -> [Loc]
possMoves board loc = case identifyColouredPiece board loc of
    Just (Filled color piece) -> case piece of
        Rook   -> validRookMoves color loc board
        Bishop -> validBishopMoves color loc board
        Queen  -> validQueenMoves color loc board
        King   -> validKingMoves color loc board
        Knight -> validKnightMoves color loc board
        Pawn   -> validPawnMoves color loc board
    _ -> []


-- Identify the piece at a specific location on the board
identifyColouredPiece :: Board -> Loc -> Maybe Square
identifyColouredPiece board (x, y)
    | x >= 0 && x < 8 && y >= 0 && y < 8 = Just ((board !! y) !! x)  -- In bounds
    | otherwise                          = Nothing                    -- Out of bounds


-- Helper function to extract the color from a Filled square
squareColor :: Square -> Maybe Colour
squareColor (Filled color _) = Just color
squareColor Empty            = Nothing

-- Extracts the piece from a Filled square if it exists
squarePiece :: Square -> Maybe Piece
squarePiece (Filled _ piece) = Just piece
squarePiece Empty            = Nothing


-- Possible Moves for Each Piece
-- Updated kingMoves with bounds checking
kingMoves :: Loc -> [Loc]
kingMoves (x, y) = filter isInBounds
    [(x+dx, y+dy) | dx <- [-1, 0, 1], dy <- [-1, 0, 1], (dx, dy) /= (0, 0)]

rookMoves :: Loc -> [Loc]
rookMoves (x, y) =
    [(x + i, y) | i <- [1..7]] ++ [(x - i, y) | i <- [1..7]] ++  -- Horizontal moves
    [(x, y + i) | i <- [1..7]] ++ [(x, y - i) | i <- [1..7]]      -- Vertical moves

bishopMoves :: Loc -> [Loc]
bishopMoves (x, y) =
    [(x + i, y + i) | i <- [1..7]] ++ [(x - i, y - i) | i <- [1..7]] ++  -- Diagonal /
    [(x + i, y - i) | i <- [1..7]] ++ [(x - i, y + i) | i <- [1..7]]      -- Diagonal \



-- Updated queenMoves with bounds checking
queenMoves :: Loc -> [Loc]
queenMoves loc = rookMoves loc ++ bishopMoves loc

-- Updated knightMoves with bounds checking
knightMoves :: Loc -> [Loc]
knightMoves (x, y) = filter isInBounds
    [(x + dx, y + dy) | (dx, dy) <- [(2, 1), (2, -1), (-2, 1), (-2, -1),
                                     (1, 2), (1, -2), (-1, 2), (-1, -2)]]

-- Pawn moves: forward one square, or two on the first move only
pawnMoves :: Square -> Loc -> [Loc]
pawnMoves (Filled color Pawn) (x, y) =
  let
      -- Determine the direction: White moves "up" the board (increasing y), Black moves "down" (decreasing y)
      forward = if color == White then 1 else -1

      -- Define the starting row for each color
      startRow = if color == White then 1 else 6

      -- One square forward
      singleMove = (x, y + forward)

      -- Two squares forward, only if on the starting row
      doubleMove = (x, y + 2 * forward)
  in
      -- Include both moves if on the starting row, otherwise just one move
      if y == startRow then [singleMove, doubleMove] else [singleMove]
pawnMoves _ _ = []

validRookMoves :: Colour -> Loc -> Board -> [Loc]
validRookMoves color loc board =
    filterValidMoves color loc (rookMoves loc) board


validBishopMoves :: Colour -> Loc -> Board -> [Loc]
validBishopMoves color loc board =
    filterValidMoves color loc (bishopMoves loc) board


validQueenMoves :: Colour -> Loc -> Board -> [Loc]
validQueenMoves color loc board =
    filterValidMoves color loc (rookMoves loc ++ bishopMoves loc) board



-- King: One square in any direction, avoiding squares with same color pieces
validKingMoves :: Colour -> Loc -> Board -> [Loc]
validKingMoves color loc board =
    filter (isOpponentOrEmpty color board) (kingMoves loc)

-- Knight: L-shaped moves, avoiding squares with same color pieces
validKnightMoves :: Colour -> Loc -> Board -> [Loc]
validKnightMoves color loc board =
    filter (isOpponentOrEmpty color board) (knightMoves loc)

-- Helper function to check if a square is empty or occupied by an opponent's piece
isOpponentOrEmpty :: Colour -> Board -> Loc -> Bool
isOpponentOrEmpty color board loc = case identifyColouredPiece board loc of
    Just Empty -> True
    Just (Filled pieceColor _) -> pieceColor /= color  -- Opponent piece
    Nothing -> False  -- Out of bounds


validPawnMoves :: Colour -> Loc -> Board -> [Loc]
validPawnMoves color (x, y) board =
    let
        -- Correct the movement direction based on color
        forward = if color == White then -1 else 1
        startRow = if color == White then 6 else 1

        -- Forward moves
        singleMove = (x, y + forward)  -- One square forward
        doubleMove = (x, y + 2 * forward)  -- Two squares forward if on start row

        -- Check if the squares in front are empty for forward moves
        forwardMoves = [singleMove | isEmpty board singleMove] ++
                       [doubleMove | y == startRow && isEmpty board singleMove && isEmpty board doubleMove]

        -- Diagonal captures (left and right)
        captureMoves = [ (x - 1, y + forward) | isOpponent color board (x - 1, y + forward) ] ++
                       [ (x + 1, y + forward) | isOpponent color board (x + 1, y + forward) ]
    in
        forwardMoves ++ captureMoves

-- Check if a location is empty
isEmpty :: Board -> Loc -> Bool
isEmpty board loc = case identifyColouredPiece board loc of
    Just Empty -> True
    _ -> False

-- Check if a location has an opponent piece
isOpponent :: Colour -> Board -> Loc -> Bool
isOpponent color board loc = case identifyColouredPiece board loc of
    Just (Filled pieceColor _) -> pieceColor /= color
    _ -> False




-- Combine Moves for Each Piece

possibleMovesForPiece :: Square -> Loc -> [Loc]
possibleMovesForPiece (Filled _ King) loc = kingMoves loc
possibleMovesForPiece (Filled _ Queen) loc = queenMoves loc
possibleMovesForPiece (Filled _ Rook) loc = rookMoves loc
possibleMovesForPiece (Filled _ Bishop) loc = bishopMoves loc
possibleMovesForPiece (Filled _ Knight) loc = knightMoves loc
possibleMovesForPiece piece@(Filled _ Pawn) loc = pawnMoves piece loc
possibleMovesForPiece Empty _ = []



-- Update a board by setting a piece at a specified location
setPieceAt :: Square -> Loc -> Board -> Board
setPieceAt square (x, y) board =
    take y board ++                       -- Rows above
    [take x (board !! y) ++ [square] ++ drop (x + 1) (board !! y)] ++  -- Row with new piece
    drop (y + 1) board                     -- Rows below


-- Check if a location is within the bounds of an 8x8 board
isInBounds :: Loc -> Bool
isInBounds (x, y) = x >= 0 && x < 8 && y >= 0 && y < 8

filterValidMoves :: Colour -> Loc -> [Loc] -> Board -> [Loc]
filterValidMoves color loc moves board =
    concatMap (takeUntilBlocked color board) (groupMovesByDirection loc moves)


groupMovesByDirection :: Loc -> [Loc] -> [[Loc]]
groupMovesByDirection (x, y) moves =
    [ filter (\(nx, ny) -> nx == x && ny > y) moves  -- Up
    , filter (\(nx, ny) -> nx == x && ny < y) moves  -- Down
    , filter (\(nx, ny) -> ny == y && nx > x) moves  -- Right
    , filter (\(nx, ny) -> ny == y && nx < x) moves  -- Left
    , filter (\(nx, ny) -> nx > x && ny > y) moves   -- Down-right
    , filter (\(nx, ny) -> nx > x && ny < y) moves   -- Up-right
    , filter (\(nx, ny) -> nx < x && ny > y) moves   -- Down-left
    , filter (\(nx, ny) -> nx < x && ny < y) moves   -- Up-left
    ]


takeUntilBlocked :: Colour -> Board -> [Loc] -> [Loc]
takeUntilBlocked _ _ [] = []
takeUntilBlocked color board (p:ps) =
    case identifyColouredPiece board p of
      Just Empty -> p : takeUntilBlocked color board ps  -- Continue if empty
      Just (Filled pieceColor _)
          | pieceColor /= color -> [p]  -- Include capture of opponent, then stop
          | otherwise -> []  -- Stop if same color piece
      Nothing -> []  -- Out of bounds



-- Create an 8x8 board filled with Empty squares
emptyBoard :: Board
emptyBoard = replicate 8 (replicate 8 Empty)





main :: IO ()
main = do
    -- Test board setup with different pieces
    let board1 = setPieceAt (Filled Black Bishop) (3, 3) emptyBoard

    print $ possMoves board1 (3,3)


