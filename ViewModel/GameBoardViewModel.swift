//
//  GameBoardViewModel.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/22.
//

import Foundation

class GameBoardViewModel: ObservableObject {
    private let _puzzle: Puzzle
    @Published private var _currentPuzzle: [[Int]] = []
    @Published private var _puzzleNotes: [[[Int]]] = []

    private let _difficulty: Difficulty
    var difficulty: Difficulty { return _difficulty }
    private var _gameStatus: GameStatus
    var gameStatus: GameStatus { return _gameStatus }
    @Published private var _hints = 3
    var hints: Int { return _hints }
    
    var blockRowCount: Int { return _puzzle.rowCount }
    var blockColumnCount: Int { return _puzzle.columnCount }
    var boardEdgeCount: Int { return _puzzle.edgeCount }
    
    @Published private var _currentRowIndex = -1
    @Published private var _currentColumnIndex = -1
    @Published var isNoteMode = false
    
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
    
    func isSelectedCell(rowIndex: Int, columnIndex: Int) -> Bool {
        return rowIndex == _currentRowIndex && columnIndex == _currentColumnIndex
    }
    
    func isPuzzle(rowIndex: Int, columnIndex: Int) -> Bool {
        return _puzzle.canModifyCell(rowIndex: rowIndex, columnIndex: columnIndex)
    }
    
    func validateBoard() -> Bool {
        if !isBoardCompleted {
            return false
        }
        
        return _puzzle.isPuzzleCorrect(currentPuzzle: _currentPuzzle)
    }
    
    func selectCell(rowIndex: Int, columnIndex: Int) {
        _currentRowIndex = rowIndex
        _currentColumnIndex = columnIndex
    }
    
    func fillCellNumber(value: Int) {
        if !_isCurrentPositionValid() {
            // print("Exception: board row and column position should be in range of 0 ..< boardEdgeCount")
            return
        }
        if !_isCellValueValid(value: value) {
            // print("Exception: value should be in range of 1 ... boardEdgeCount")
            return
        }
        if !_puzzle.canModifyCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
            // print("Exception: cell cannot take notes because it is part of the given puzzle")
            return
        }
        if isNoteMode {
            _updateCellNotes(value: value)
            return
        }
        
        _currentPuzzle[_currentRowIndex][_currentColumnIndex] = value
        // clear notes after filled an answer to the cell
//        _puzzleNotes[_currentRowIndex][_currentColumnIndex].removeAll()
    }
    
    func clearCellNumber() {
        if !_isCurrentPositionValid() {
            // print("Exception: board row and column position should be in range of 0 ..< boardEdgeCount")
            return
        }
        if !_puzzle.canModifyCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
            // print("Exception: cell cannot be cleared because it is part of the given puzzle")
            return
        }
        
        _currentPuzzle[_currentRowIndex][_currentColumnIndex] = 0
        // clear notes
//        _puzzleNotes[_currentRowIndex][_currentColumnIndex].removeAll()
    }
    
    func changeNoteMode() {
        isNoteMode = !isNoteMode
    }
    
    // return notes of a cell, if it is empty, should return nil
    func getNotes(rowIndex: Int, columnIndex: Int) -> String? {
        if _puzzle.canModifyCell(rowIndex: rowIndex, columnIndex: columnIndex) {
//            if !_puzzleNotes[rowIndex][columnIndex].isEmpty {
//                /*
//                 return puzzle notes here, can try use the code below to convert [Int] to String?
//                    let notes = _puzzleNotes[rowIndex][columnIndex].map  { Optional(String($0)) }  // [Int] -> [String?]
//                    let noteString = notes.joined(separator: " ")        // [String?] -> String?
//                 */
//            }
            if rowIndex < 4 {
                return "1 3 5 8 9"
            }
        }
        return nil
    }
    
    private func _updateCellNotes(value: Int) {
        if !_isCurrentPositionValid() {
            // print("Exception: board row and column position should be in range of 0 ..< boardEdgeCount")
            return
        }
        if _isCellValueValid(value: value) {
            // print("Exception: value shoule be in range of 1 ... boardEdgeCount")
            return
        }
        if !_puzzle.canModifyCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
            // print("Exception: cell cannot take notes because it is part of the given puzzle")
            return
        }
        
        // remove if number exists in note list, else add number to note list
        if _puzzleNotes[_currentRowIndex][_currentColumnIndex].contains(value) {
            if let index = _puzzleNotes[_currentRowIndex][_currentColumnIndex].firstIndex(of: value) {
                _puzzleNotes[_currentRowIndex][_currentColumnIndex].remove(at: index)
            }
        } else {
            _puzzleNotes[_currentRowIndex][_currentColumnIndex].append(value)
        }
    }
    
    // automatically fill hint answer to random blank position
    func useHint() {
        if _hints <= 0 {
            return
        }
        
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
        _hints -= 1
    }
    
    private func _isCellValueValid(value: Int) -> Bool {
        return value >= 1 && value <= boardEdgeCount
    }
    
    private func _isCurrentPositionValid() -> Bool {
        return _currentRowIndex >= 0 && _currentRowIndex < boardEdgeCount && _currentColumnIndex >= 0 && _currentColumnIndex < boardEdgeCount
    }
}
