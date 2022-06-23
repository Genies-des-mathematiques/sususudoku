//
//  GameBoardViewModel.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/22.
//

import Foundation

class GameBoardViewModel {
    private let _puzzle: Puzzle
    private var _currentPuzzle: [[Int]] = []
    private var _puzzleNotes: [[[Int]]] = []

    private let _difficulty: Difficulty
    var difficulty: Difficulty { return _difficulty }
    private var _gameStatus: GameStatus
    var gameStatus: GameStatus { return _gameStatus }

    var blockRowCount: Int { return _puzzle.rowCount }
    var blockColumnCount: Int { return _puzzle.columnCount }
    var boardEdgeCount: Int { return _puzzle.edgeCount }
    
    var isBoardCompleted: Bool {
        for row in _currentPuzzle {
            if row.contains(0) {
                return false
            }
        }
        return true
    }

    init(_ rowCount: Int, _ columnCount: Int, _ difficulty: Difficulty, _ gameStatus: GameStatus) {
        _puzzle = Puzzle(rowCount, columnCount)
        _currentPuzzle = _puzzle.problemPuzzle
        _difficulty = difficulty
        _gameStatus = gameStatus
    }

    func getCellText(rowIndex: Int, columnIndex: Int) -> String {
        let value = _currentPuzzle[rowIndex][columnIndex]
        return value == 0 ? "" : "\(value)"
    }
    
    func validateBoard() -> Bool {
        if !isBoardCompleted {
            return false
        }
        
        return _puzzle.isPuzzleCorrect(currentPuzzle: _currentPuzzle)
    }
    
    func fillCellNumber(rowIndex: Int, columnIndex: Int, value: Int) {
        if _isCellValueValid(value: value) {
            // Exception: value shoule be in range of 1 ... boardEdgeCount
            return
        }
        if !_isPositionIndexValid(index: rowIndex) || !_isPositionIndexValid(index: columnIndex) {
            // Exception: board row and column position should be in range of 0 ..< boardEdgeCount
            return
        }
        
        _currentPuzzle[rowIndex][columnIndex] = value
    }
    
    func clearCellNumber(rowIndex: Int, columnIndex: Int) {
        if !_isPositionIndexValid(index: rowIndex) || !_isPositionIndexValid(index: columnIndex) {
            // Exception: board row and column position should be in range of 0 ..< boardEdgeCount
            return
        }
        if _puzzle.canModifyCell(rowIndex: rowIndex, columnIndex: columnIndex) {
            // Exception: cell cannot be cleared because it is part of the given puzzle
            return
        }
        
        _currentPuzzle[rowIndex][columnIndex] = 0
    }
    
    func updateCellNotes(rowIndex: Int, columnIndex: Int, value: Int) {
        if _isCellValueValid(value: value) {
            // Exception: value shoule be in range of 1 ... boardEdgeCount
            return
        }
        if !_isPositionIndexValid(index: rowIndex) || !_isPositionIndexValid(index: columnIndex) {
            // Exception: board row and column position should be in range of 0 ..< boardEdgeCount
            return
        }
        if _puzzle.canModifyCell(rowIndex: rowIndex, columnIndex: columnIndex) {
            // Exception: cell cannot take notes because it is part of the given puzzle
            return
        }
        
        // remove if number exists in note list, else add number to note list
        if _puzzleNotes[rowIndex][columnIndex].contains(value) {
            if let index = _puzzleNotes[rowIndex][columnIndex].firstIndex(of: value) {
                _puzzleNotes[rowIndex][columnIndex].remove(at: index)
            }
        } else {
            _puzzleNotes[rowIndex][columnIndex].append(value)
        }
    }
    
    // automatically fill hint answer to random blank position
    func useHint() {
        var blankPositions: [Int] = []
        
        for position in 0 ..< boardEdgeCount * boardEdgeCount {
            let rowIndex = position / boardEdgeCount
            let columnIndex = position % boardEdgeCount
            if _currentPuzzle[rowIndex][columnIndex] == 0 {
                blankPositions.append(position)
            }
        }
        
        let hintPosition = blankPositions.randomElement()!
        let hintRowIndex = hintPosition / boardEdgeCount
        let hintColumnIndex = hintPosition % boardEdgeCount
        
        _currentPuzzle[hintRowIndex][hintColumnIndex] = _puzzle.getCellAnswer(rowIndex: hintRowIndex, columnIndex: hintColumnIndex)
    }
    
    private func _isCellValueValid(value: Int) -> Bool {
        return value >= 1 && value <= boardEdgeCount
    }
    
    private func _isPositionIndexValid(index: Int) -> Bool {
        return index >= 0 && index < boardEdgeCount
    }
}
