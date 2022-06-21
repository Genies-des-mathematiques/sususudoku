//
//  Puzzle.swift
//  sususudoku
//
//  Created by Eddie on 2022/6/17.
//

import Foundation

// TODO: should combine with Grid.swift, should move code logic related to View to ViewModel

final class Puzzle {
    private let _rowCount = 3
    private let _columnCount = 3
    private var _edgeCount: Int
    private var _currentPuzzle: [[Int]] = []
    private var _answerPuzzle: [[Int]] = []
    private var _problemPuzzle: [[Int]] = []
    private var _puzzleSolvesCount = 0

    init() {
        _edgeCount = _rowCount * _columnCount
        _problemPuzzle = [[Int]](repeating: [Int](repeating: 0, count: _edgeCount), count: _edgeCount)
        _generatePuzzle()
    }

    func render(rowIndex: Int, columnIndex: Int) -> Int {
        return _currentPuzzle[rowIndex][columnIndex]
    }

    // TODO: throw exception when fail to generate valid sudoku puzzle
    private func _generatePuzzle() {
        if _fillPuzzle() {
            _answerPuzzle = _problemPuzzle
            _hollowOutPuzzle()
            _currentPuzzle = _problemPuzzle
        } else {
            fatalError("fail to generate valid sudoku puzzle")
        }
    }

    private func _isPuzzleCompleted(puzzle: [[Int]]) -> Bool {
        for rowIndex in 0 ..< _edgeCount {
            for columnIndex in 0 ..< _edgeCount {
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

    private func _isSquareNotDuplicate(currentPuzzle: [[Int]], rowIndex: Int, columnIndex: Int, value: Int) -> Bool {
        var square: [Int] = []
        let startRowIndex = rowIndex / _rowCount * _rowCount
        let startColumnIndex = columnIndex / _columnCount * _columnCount

        for i in startRowIndex ... startRowIndex + _rowCount - 1 {
            for j in startColumnIndex ... startColumnIndex + _columnCount - 1 {
                square.append(currentPuzzle[i][j])
            }
        }
        return !square.contains(value)
    }

    private func _solvePuzzle(puzzle: [[Int]]) -> Bool {
        let numberList = Array(1 ... _edgeCount)
        var testPuzzle = puzzle
        var rowIndex = 0
        var columnIndex = 0

        for index in 0 ..< _edgeCount * _edgeCount {
            rowIndex = index / _edgeCount
            columnIndex = index % _edgeCount
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
                        _isSquareNotDuplicate(
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
        var numberList = Array(1 ... _edgeCount)
        var rowIndex = 0
        var columnIndex = 0
        for index in 0 ..< _edgeCount * _edgeCount {
            rowIndex = index / _edgeCount
            columnIndex = index % _edgeCount
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
                        _isSquareNotDuplicate(
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
        var attempts = 1 // difficulty
        _puzzleSolvesCount = 1
        while attempts > 0 {
            var numberList: [Int] = []
            for count in 0 ..< _edgeCount * _edgeCount {
                numberList.append(count)
            }
            numberList.shuffle()
            for index in numberList {
                let rowIndex = index / _edgeCount
                let columnIndex = index % _edgeCount
                let backup = _problemPuzzle[rowIndex][columnIndex]
                _problemPuzzle[rowIndex][columnIndex] = 0
                let copyPuzzle: [[Int]] = _problemPuzzle

                _puzzleSolvesCount = 0
                if _solvePuzzle(puzzle: copyPuzzle) && _puzzleSolvesCount != 1 {
                    _problemPuzzle[rowIndex][columnIndex] = backup
                    attempts -= 1
                    break
                }
            }
            attempts -= 1
        }
    }
}
