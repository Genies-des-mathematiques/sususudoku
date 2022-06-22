//
//  Puzzle.swift
//  sususudoku
//
//  Created by Eddie on 2022/6/17.
//

import Foundation

// TODO: should move code logic related to View to ViewModel

final class Puzzle {
    private var _currentPuzzle: [[Int]] = []
    private var _answerPuzzle: [[Int]] = []
    private var _problemPuzzle: [[Int]] = []
    private var _puzzleSolvesCount = 0

    private var _rowCount = 3
    var rowCount: Int { return _rowCount }
    private var _columnCount = 3
    var columnCount: Int { return _columnCount }
    var edgeCount: Int { return _rowCount * _columnCount }

    init(_ rowCount: Int, _ columnCount: Int) {
        print("Puzzle: start init")
        _rowCount = rowCount
        _columnCount = columnCount
        _problemPuzzle = [[Int]](repeating: [Int](repeating: 0, count: edgeCount), count: edgeCount)
        _generatePuzzle()

        print("Puzzle: initialized")
        print("----- problem puzzle -----")
        print(_problemPuzzle)
        print("----- answer puzzle -----")
        print(_answerPuzzle)
    }

    func getNumber(rowIndex: Int, columnIndex: Int) -> Int {
        return _currentPuzzle[rowIndex][columnIndex]
    }

    // TODO: throw exception when fail to generate valid sudoku puzzle
    private func _generatePuzzle() {
        print("Puzzle: randomly filling numbers ... ")
        if _fillPuzzle() {
            _answerPuzzle = _problemPuzzle
            print("Puzzle: starting to remove out numbers ... ")
            _hollowOutPuzzle()
            print("Puzzle: generate problem success")
            _currentPuzzle = _problemPuzzle
        } else {
            print("Puzzle: generate problem failed")
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
        print("Puzzle -> _hollowOutPuzzle(): hollowLimit = \(hollowLimit)")

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
                    print("Puzzle -> _hollowOutPuzzle(): does not hav exactly one solution, hollow out stopped")
                    break
                }

                if hollowCount >= hollowLimit {
                    print("Puzzle -> _hollowOutPuzzle(): reached hollowLimit \(hollowLimit), hollow out stopped")
                    break
                }

                print("Puzzle -> _hollowOutPuzzle(): removed number in \(rowIndex), \(columnIndex) success")
                hollowCount += 1
            }
            attempts -= 1
        }
    }
}
