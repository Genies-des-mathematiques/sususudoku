//
//  Puzzle.swift
//  sususudoku
//
//  Created by Eddie on 2022/6/17.
//

import Foundation

final class Puzzle {
    private var _answerPuzzle: [[Int]] = []
    private var _problemPuzzle: [[Int]] = []
    var problemPuzzle: [[Int]] { return _problemPuzzle }
    private var _puzzleSolvesCount = 0

    private var _rowCount = 3
    var rowCount: Int { return _rowCount }
    private var _columnCount = 3
    var columnCount: Int { return _columnCount }
    var edgeCount: Int { return _rowCount * _columnCount }

    init(_ rowCount: Int, _ columnCount: Int) {
        _rowCount = rowCount
        _columnCount = columnCount
        resetGame()
    }
    
    func isPuzzleCorrect(currentPuzzle: [[Int]]) -> Bool {
        for i in 0 ..< edgeCount {
            for j in 0 ..< edgeCount {
                if currentPuzzle[i][j] != _answerPuzzle[i][j] {
                    return false
                }
            }
        }
        return true
    }
    
    func canModifyCell(rowIndex: Int, columnIndex: Int) -> Bool {
        return _problemPuzzle[rowIndex][columnIndex] == 0
    }
    
    func getCellAnswer(rowIndex: Int, columnIndex: Int) -> Int {
        return _answerPuzzle[rowIndex][columnIndex]
    }

    func resetGame() {
        _problemPuzzle = [[Int]](repeating: [Int](repeating: 0, count: edgeCount), count: edgeCount)
        _answerPuzzle = []
        _generatePuzzle()
    }

    private func _generatePuzzle() {
        if _fillPuzzle() {
            _answerPuzzle = _problemPuzzle
            _hollowOutPuzzle()
        } else {
            print("Puzzle: generate problem failed") // TODO: should throw exception or use debug load
        }
    }

    private func _isPuzzleCompleted(puzzle: [[Int]]) -> Bool {
        for rowIndex in 0 ..< edgeCount {
            for columnIndex in 0 ..< edgeCount {
                if puzzle[rowIndex][columnIndex] == 0 {
                    return false
                }
            }
        }
        return true
    }

    private func _isRowNotDuplicate(currentPuzzle: [[Int]], rowIndex: Int, value: Int) -> Bool {
        return !currentPuzzle[rowIndex].contains(value)
    }

    private func _isColumnNotDuplicate(currentPuzzle: [[Int]], columnIndex: Int, value: Int) -> Bool {
        let column: [Int] = currentPuzzle.map { $0[columnIndex] }
        return !column.contains(value)
    }

    private func _isBlockNotDuplicate(currentPuzzle: [[Int]], rowIndex: Int, columnIndex: Int, value: Int) -> Bool {
        var block: [Int] = []
        let startRowIndex = rowIndex / _rowCount * _rowCount
        let startColumnIndex = columnIndex / _columnCount * _columnCount

        for i in startRowIndex ... startRowIndex + _rowCount - 1 {
            for j in startColumnIndex ... startColumnIndex + _columnCount - 1 {
                block.append(currentPuzzle[i][j])
            }
        }
        return !block.contains(value)
    }

    private func _solvePuzzle(puzzle: [[Int]]) -> Bool {
        let numberList = Array(1 ... edgeCount)
        var testPuzzle = puzzle
        var rowIndex = 0
        var columnIndex = 0

        for index in 0 ..< edgeCount * edgeCount {
            rowIndex = index / edgeCount
            columnIndex = index % edgeCount
            if testPuzzle[rowIndex][columnIndex] == 0 {
                for value in numberList {
                    if _isRowNotDuplicate(
                        currentPuzzle: testPuzzle,
                        rowIndex: rowIndex,
                        value: value
                    ),
                        _isColumnNotDuplicate(
                            currentPuzzle: testPuzzle,
                            columnIndex: columnIndex,
                            value: value
                        ),
                        _isBlockNotDuplicate(
                            currentPuzzle: testPuzzle,
                            rowIndex: rowIndex,
                            columnIndex: columnIndex,
                            value: value
                        )
                    {
                        testPuzzle[rowIndex][columnIndex] = value
                        if _isPuzzleCompleted(puzzle: testPuzzle) {
                            _puzzleSolvesCount += 1
                            break
                        } else {
                            if _solvePuzzle(puzzle: testPuzzle) {
                                return true
                            }
                        }
                    }
                }
                break
            }
        }

        testPuzzle[rowIndex][columnIndex] = 0
        return false
    }

    private func _fillPuzzle() -> Bool {
        var numberList = Array(1 ... edgeCount)
        var rowIndex = 0
        var columnIndex = 0
        for index in 0 ..< edgeCount * edgeCount {
            rowIndex = index / edgeCount
            columnIndex = index % edgeCount
            if _problemPuzzle[rowIndex][columnIndex] == 0 {
                numberList.shuffle()
                for value in numberList {
                    if _isRowNotDuplicate(
                        currentPuzzle: _problemPuzzle,
                        rowIndex: rowIndex,
                        value: value
                    ) &&
                        _isColumnNotDuplicate(
                            currentPuzzle: _problemPuzzle,
                            columnIndex: columnIndex,
                            value: value
                        ) &&
                        _isBlockNotDuplicate(
                            currentPuzzle: _problemPuzzle,
                            rowIndex: rowIndex,
                            columnIndex: columnIndex,
                            value: value
                        )
                    {
                        _problemPuzzle[rowIndex][columnIndex] = value

                        if _isPuzzleCompleted(puzzle: _problemPuzzle) {
                            return true
                        } else {
                            if _fillPuzzle() {
                                return true
                            }
                        }
                    }
                }
                break
            }
        }
        _problemPuzzle[rowIndex][columnIndex] = 0
        return false
    }

    private func _hollowOutPuzzle() {
        let mid = edgeCount * edgeCount / 2
        let diff = edgeCount * edgeCount / 20
        let hollowLimit = Int.random(in: mid - diff ... mid + diff) // the number of blocks that should hollow out
        var hollowCount = 0
        var attempts = 1 // difficulty
        _puzzleSolvesCount = 1

        while attempts > 0 {
            var numberList = Array(0 ..< edgeCount * edgeCount)
            numberList.shuffle()

            for index in numberList {
                let rowIndex = index / edgeCount
                let columnIndex = index % edgeCount
                let backup = _problemPuzzle[rowIndex][columnIndex]
                _problemPuzzle[rowIndex][columnIndex] = 0
                let copyPuzzle: [[Int]] = _problemPuzzle

                _puzzleSolvesCount = 0
                if _solvePuzzle(puzzle: copyPuzzle) && _puzzleSolvesCount != 1 {
                    _problemPuzzle[rowIndex][columnIndex] = backup
                    attempts -= 1
                    break
                }

                hollowCount += 1
                if hollowCount >= hollowLimit {
                    break
                }
            }
            attempts -= 1
        }
    }
}
