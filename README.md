# Chess
Haskell chess program
Chess Movement Engine in Haskell
Overview
This project is a chess movement engine implemented in Haskell, designed to calculate possible moves for each chess piece on a given board state. The engine enforces the rules of chess for each piece, accounting for movement patterns, board boundaries, and obstructions by other pieces. The goal is to provide a flexible and robust tool for chess-based applications, suitable for integration into a full chess game or as a foundational component for AI development.

Features
Piece-Specific Movement: Implements the distinct movement rules for each type of chess piece.
Obstruction and Capture Handling: Calculates moves based on board obstructions, allowing captures of opponent pieces but blocking friendly pieces.
Board Boundary Enforcement: Ensures that moves remain within the 8x8 chessboard.
Functional Design with Immutability: Utilizes Haskell’s functional programming model to ensure immutability and separation of concerns.
This movement engine serves as a foundation for chess-related applications, allowing further development into full gameplay mechanics, AI simulations, or chess problem-solving tools.

Code Structure
Data Types
The code defines core data types to represent the chessboard, pieces, and locations, ensuring type safety and clarity:

Piece: Enumerates the types of pieces (Pawn, Knight, Bishop, Rook, Queen, King).
Colour: Represents the color of a piece (White or Black).
Square: Represents a square on the board, which can be empty or occupied by a piece of a given color.
Board: Represents the entire chessboard as a 2D list of squares.
Loc: Represents a position on the board using (row, column) coordinates.
Core Functions
Each chess piece has a dedicated movement function, designed to generate all possible moves from a given location on an empty board. These movement functions follow standard chess rules, ignoring obstructions initially. For example:

rookMoves: Generates horizontal and vertical moves.
bishopMoves: Generates diagonal moves.
queenMoves: Combines rook and bishop moves for full movement coverage.
kingMoves: Generates moves one square in any direction.
knightMoves: Generates "L"-shaped moves typical of a knight.
pawnMoves: Handles forward movement and captures for pawns based on their color.
Obstruction Handling
The engine includes a filtering system to handle obstructions, which:

Stops moves when a piece (friendly or opponent) obstructs the path.
Allows capturing opponent pieces but blocks further moves in that direction.
Groups moves by direction (horizontal, vertical, diagonal) to enforce stopping at the first obstruction in each direction.
Example: Filtering Moves with filterValidMoves
filterValidMoves is a helper function that takes a list of moves and stops at the first obstruction. It leverages Haskell’s functional composition to process each move list independently for each direction, ensuring that moves are restricted as per chess rules.

Additional Utilities
The code includes utility functions to:

Identify the piece on a square.
Determine the color of a piece for handling captures.
Set up a board with pieces at specified locations for testing.
Testing
The program includes test cases for each piece and board configuration, verifying that:

Each piece generates its movement correctly.
Moves stop correctly at obstructions.
Captures are handled appropriately.
Installation


Clone the repository and load it into GHCi or any Haskell development environment:

bash
Copy code
git clone https://github.com/yourusername/chess-movement-engine.git
cd chess-movement-engine
ghci Main.hs
Usage
Run the main program to see example moves for each piece or use specific functions for testing:

haskell
Copy code
main
In ghci, you can directly test piece movement functions or board configurations:

haskell
Copy code
let board = setPieceAt (Filled White Rook) (3,3) emptyBoard
print $ validRookMoves White (3, 3) board
Future Development
This engine can be expanded or integrated into larger projects, such as:

Full chess gameplay: Adding game state management, turns, check/checkmate detection.
Chess AI: Using the move generation to simulate and evaluate possible moves for building chess AI.
Puzzle Solving and Analysis: Adapting the engine to solve chess puzzles or analyze specific positions.


Acknowledgments
Thank you to all contributors and reviewers who have provided feedback for improving this engine.
