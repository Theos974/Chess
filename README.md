# Haskell Chess Movement Engine

## Overview
The Haskell Chess Movement Engine is designed to calculate possible moves for each chess piece on a given board state. It enforces chess movement rules, board boundaries, and piece interactions, serving as a flexible foundation for chess-based applications. This engine can be integrated into full chess games, used for AI development, or as a tool for solving chess problems.

## Features
- **Piece-Specific Movement**: Implements distinct movement rules for each chess piece.
- **Obstruction and Capture Handling**: Calculates moves, handling obstructions and allowing captures.
- **Board Boundary Enforcement**: Keeps moves within the 8x8 board limits.
- **Functional Design with Immutability**: Utilizes Haskell's functional programming principles to maintain immutability and separation of concerns.

This engine provides a foundation for further development into full gameplay mechanics, AI simulations, or chess problem-solving tools.

## Code Structure

### Data Types
The core data types maintain type safety and provide clarity:
- `Piece`: Enumerates chess piece types (Pawn, Knight, Bishop, Rook, Queen, King).
- `Colour`: Represents piece colors (White, Black).
- `Square`: Represents a square on the board, either empty or occupied by a piece of a given color.
- `Board`: Represents the chessboard as a 2D list of squares.
- `Loc`: Represents a position on the board using (row, column) coordinates.

### Core Functions
Each chess piece has a dedicated movement function that generates possible moves from a given location, initially ignoring obstructions:
- **`rookMoves`**: Generates horizontal and vertical moves.
- **`bishopMoves`**: Generates diagonal moves.
- **`queenMoves`**: Combines rook and bishop moves.
- **`kingMoves`**: Generates moves one square in any direction.
- **`knightMoves`**: Generates "L"-shaped moves.
- **`pawnMoves`**: Handles forward movement and captures based on color.

### Obstruction Handling
The engine uses a filtering system to handle obstructions:
- Stops moves when a piece (friendly or opponent) obstructs the path.
- Allows capturing opponent pieces but blocks further moves in that direction.
- Groups moves by direction (horizontal, vertical, diagonal) to stop at the first obstruction in each direction.

### Example: Filtering Moves with `filterValidMoves`
`filterValidMoves` is a helper function that takes a list of moves and stops at the first obstruction. It processes each move list independently for each direction, ensuring moves are restricted as per chess rules.

### Additional Utilities
- Identifies the piece on a square.
- Determines the color of a piece for capture handling.
- Sets up a board with pieces at specified locations for testing.

## Testing
The program includes test cases for each piece and board configuration, verifying:
- Each piece generates its movement correctly.
- Moves stop correctly at obstructions.
- Captures are handled appropriately.

## Installation
Clone the repository and load it into GHCi or any Haskell development environment:
```bash
git clone https://github.com/Theos974/chess-movement-engine.git
cd chess-movement-engine
ghci Main.hs
```

## Usage
Run the main program to see example moves for each piece or use specific functions for testing:
```haskell
main
```
In GHCi, you can directly test piece movement functions or board configurations:
```haskell
let board = setPieceAt (Filled White Rook) (3, 3) emptyBoard
print $ validRookMoves White (3, 3) board
```

## Future Development
This engine can be expanded or integrated into larger projects, such as:
- **Full Chess Gameplay**: Adding game state management, turns, and check/checkmate detection.
- **Chess AI**: Using the move generation to simulate and evaluate moves for AI development.
- **Puzzle Solving and Analysis**: Adapting the engine to solve chess puzzles or analyze specific positions.

## Acknowledgments
Thank you to all contributors and reviewers who have provided feedback for improving this engine.
