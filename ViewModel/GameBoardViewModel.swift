//
//  GameBoardViewModel.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/22.
//

import Foundation

class GameBoardViewModel: ObservableObject {
    @Published private var _currentPuzzle: [[Int]] = []
    @Published private var _puzzleNotes: [[[Int]]] = []
    @Published private var _currentRowIndex = -1
    @Published private var _currentColumnIndex = -1
    @Published private(set) var isNoteMode = false
    @Published private(set) var isTimerCounting = false
    @Published private(set) var hints = 3
    @Published private(set) var timeString = "00:00"
    
    private let _puzzle: Puzzle
    private let _difficulty: Difficulty
    private let _gameRecordStore: GameRecordStore
    private let _gameStart = GameStatus(status: "Play", displayIconName: "pause")
    private let _gamePause = GameStatus(status: "Pause", displayIconName: "play.fill")
    private var _gameStatus: GameStatus
    private var _timer: Timer
    private var _time = 0
    
    var difficulty: Difficulty { _difficulty }
    var gameStatus: GameStatus { _gameStatus }
    var blockRowCount: Int { _puzzle.rowCount }
    var blockColumnCount: Int { _puzzle.columnCount }
    var boardEdgeCount: Int { _puzzle.edgeCount }
    var canUseHints: Bool { hints > 0 }
    var isBoardCompleted: Bool { _currentPuzzle.first { $0.contains(0) } == nil }
    var isBoardValid: Bool {
        isBoardCompleted && _puzzle.isPuzzleCorrect(currentPuzzle: _currentPuzzle)
    }

    init(_ rowCount: Int, _ columnCount: Int, _ difficulty: Difficulty) {
        _puzzle = Puzzle(rowCount, columnCount)
        _currentPuzzle = _puzzle.problemPuzzle
        _difficulty = difficulty
        _gameStatus = _gameStart
        _puzzleNotes = [[[Int]]](repeating: [[Int]](repeating: [], count: 100), count: 100)
        _timer = Timer()
        _gameRecordStore = CreateGameRecordStore()
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
        if !_isIndexValid(index: rowIndex) || !_isIndexValid(index: columnIndex) {
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
            return
        }
        if !_isCellValueValid(value: value) {
            return
        }
        if !_puzzle.canModifyCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
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
            return
        }
        if !_puzzle.canModifyCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
            return
        }
        
        _currentPuzzle[_currentRowIndex][_currentColumnIndex] = 0
        _puzzleNotes[_currentRowIndex][_currentColumnIndex].removeAll()
    }
    
    func toggleNoteMode() {
        isNoteMode = !isNoteMode
    }
    
    func useHint() {
        if !canUseHints {
            return
        }
        if !_isCurrentPositionValid() {
            return
        }
        if !isPuzzleCell(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex) {
            return
        }
        
        _currentPuzzle[_currentRowIndex][_currentColumnIndex] = _puzzle.getCellAnswer(rowIndex: _currentRowIndex, columnIndex: _currentColumnIndex)
        hints -= 1
    }
    
    func revealAnswer() {
        for rowIndex in 0 ..< boardEdgeCount {
            for columnIndex in 0 ..< boardEdgeCount {
                if isPuzzleCell(rowIndex: rowIndex, columnIndex: columnIndex) {
                    _currentPuzzle[rowIndex][columnIndex] = _puzzle.getCellAnswer(rowIndex: rowIndex, columnIndex: columnIndex)
                }
            }
        }
    }
    
    func startTimer() {
        _gameStatus = _gameStart
        isTimerCounting = true
        _timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self._time += 1
            self.timeString = self._convertSecondsToTime(timeInSeconds: self._time)
        })
    }
    
    func pauseTimer() {
        _gameStatus = _gamePause
        isTimerCounting = false
        _timer.invalidate()
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
    
    private func _convertSecondsToTime(timeInSeconds: Int) -> String {
        let minutes = timeInSeconds / 60
        let seconds = timeInSeconds % 60
        let hours = timeInSeconds / 3600

        if timeInSeconds < 3600 {
            return String(format: "%02i:%02i", minutes, seconds)
        }
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    private func _isCellValueValid(value: Int) -> Bool {
        return value >= 1 && value <= boardEdgeCount
    }
    
    private func _isCurrentPositionValid() -> Bool {
        return _isIndexValid(index: _currentRowIndex) && _isIndexValid(index: _currentColumnIndex)
    }
    
    private func _isIndexValid(index: Int) -> Bool {
        return index >= 0 && index < boardEdgeCount
    }
}
