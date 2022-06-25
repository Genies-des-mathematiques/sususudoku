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
        _currentPuzzle.first { $0.contains(0) } == nil
    }
    
    var isBoardValid: Bool {
        isBoardCompleted && _puzzle.isPuzzleCorrect(currentPuzzle: _currentPuzzle)
    }

    init(_ rowCount: Int, _ columnCount: Int, _ difficulty: Difficulty, defaultStatus gameStatus: GameStatus) {
        _puzzle = Puzzle(rowCount, columnCount)
        _currentPuzzle = _puzzle.problemPuzzle
        _difficulty = difficulty
        _gameStatus = gameStatus
        _puzzleNotes = [[[Int]]](repeating: [[Int]](repeating: [], count: 100), count: 100)
    }

    func getCellText(rowIndex: Int, columnIndex: Int) -> String {
        if isShowingNotes(rowIndex: rowIndex, columnIndex: columnIndex) {
            let notes = _puzzleNotes[rowIndex][columnIndex].map { "\($0)" }
            return notes.joined(separator: " ")
        } else {
            let value = _currentPuzzle[rowIndex][columnIndex]
            return value == 0 ? "" : "\(value)"
        }
    }
    
    func isSelectedCell(rowIndex: Int, columnIndex: Int) -> Bool {
        return rowIndex == _currentRowIndex && columnIndex == _currentColumnIndex
    }
    
    func isPuzzleCell(rowIndex: Int, columnIndex: Int) -> Bool {
        return _puzzle.canModifyCell(rowIndex: rowIndex, columnIndex: columnIndex)
    }
    
    func isShowingNotes(rowIndex: Int, columnIndex: Int) -> Bool {
        if !(rowIndex >= 0 && rowIndex < boardEdgeCount && columnIndex >= 0 && columnIndex < boardEdgeCount) {
            return false
        }
        
        let cellValue = _currentPuzzle[rowIndex][columnIndex]
        return cellValue == 0 && !_puzzleNotes[rowIndex][columnIndex].isEmpty
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
            _currentPuzzle[_currentRowIndex][_currentColumnIndex] = 0
            _updateCellNotes(value: value)
        } else {
            _puzzleNotes[_currentRowIndex][_currentColumnIndex].removeAll()
            _currentPuzzle[_currentRowIndex][_currentColumnIndex] = value
        }
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
        _puzzleNotes[_currentRowIndex][_currentColumnIndex].removeAll()
    }
    
    func changeNoteMode() {
        isNoteMode = !isNoteMode
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
    
    func fillHollow() {
        for i in 0 ..< 9 {
            for j in 0 ..< 9 {
                if _currentPuzzle[i][j] == 0 {
                    _currentPuzzle[i][j] = 1
                }
            }
        }
    }
    
    private func _updateCellNotes(value: Int) {
        var currentNoteCells = _puzzleNotes[_currentRowIndex][_currentColumnIndex]
        if currentNoteCells.contains(value) {
            if let index = currentNoteCells.firstIndex(of: value) {
                _puzzleNotes[_currentRowIndex][_currentColumnIndex].remove(at: index)
            }
        } else {
            currentNoteCells.append(value)
            _puzzleNotes[_currentRowIndex][_currentColumnIndex] = currentNoteCells.sorted()
        }
    }
    
    private func _isCellValueValid(value: Int) -> Bool {
        return value >= 1 && value <= boardEdgeCount
    }
    
    private func _isCurrentPositionValid() -> Bool {
        return _currentRowIndex >= 0 && _currentRowIndex < boardEdgeCount && _currentColumnIndex >= 0 && _currentColumnIndex < boardEdgeCount
    }
}
