//
//  Puzzle.swift
//  sususudoku
//
//  Created by Eddie on 2022/6/17.
//

import Foundation
import SwiftUI

//TODO: should combine with Grid.swift, should move code logic related to View to ViewModel

final class Puzzle: ObservableObject {
    @Published private var grid: [[Int]] = .init()
    var counter = 0
    
    var sudokuAnswer: [[Int]] = []
    var sudoku = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]

    init() {
        if fillSudoku() {
            sudokuAnswer = sudoku
            hollowOutSudoku()
            self.grid = sudoku
        }
        else {
            fatalError("fail to generate valid sudoku puzzle")
        }
    }

    func render(row: Int, col: Int) -> Text {
        let value: Int = grid[row][col]

        if value == 0 {
            return Text("")
        }

        return Text("\(value)")
            .font(.title)
    }

    func checkSudoku(sudoku: [[Int]]) -> Bool {
        for row in 0...8 {
            for column in 0...8 {
                if sudoku[row][column] == 0 {
                    return false
                }
            }
        }
        return true
    }

    func solveSudoku(sudoku: [[Int]]) -> Bool {
        var targetSudoku = sudoku
        let numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var row = 0
        var column = 0
        for index in 0...80 {
            row = index / 9
            column = index % 9
            if targetSudoku[row][column] == 0 {
                for value in numberList {
                    if !targetSudoku[row].contains(value) {
                        if ![targetSudoku[0][column], targetSudoku[1][column], targetSudoku[2][column], targetSudoku[3][column], targetSudoku[4][column], targetSudoku[5][column], targetSudoku[6][column], targetSudoku[7][column], targetSudoku[8][column]].contains(value) {
                            var square: [Int] = []
                            for i in 0...2 {
                                for j in 0...2 {
                                    square.append(targetSudoku[row / 3 * 3 + i][column / 3 * 3 + j])
                                }
                            }
                            if !square.contains(value) {
                                targetSudoku[row][column] = value
                                if checkSudoku(sudoku: targetSudoku) {
                                    counter += 1
                                    break
                                } else {
                                    if solveSudoku(sudoku: targetSudoku) {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
                break
            }
        }
        targetSudoku[row][column] = 0
        return false
    }

    func fillSudoku() -> Bool {
        var numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        var row = 0
        var column = 0
        for index in 0...80 {
            row = index / 9
            column = index % 9
            if sudoku[row][column] == 0 {
                numberList.shuffle()
                for value in numberList {
                    if !sudoku[row].contains(value) {
                        if ![sudoku[0][column], sudoku[1][column], sudoku[2][column], sudoku[3][column], sudoku[4][column], sudoku[5][column], sudoku[6][column], sudoku[7][column], sudoku[8][column]].contains(value) {
                            var square: [Int] = []
                            for i in 0...2 {
                                for j in 0...2 {
                                    square.append(sudoku[row / 3 * 3 + i][column / 3 * 3 + j])
                                }
                            }
                            if !square.contains(value) {
                                sudoku[row][column] = value
                                if checkSudoku(sudoku: sudoku) {
                                    return true
                                } else {
                                    if fillSudoku() {
                                        return true
                                    }
                                }
                            }
                        }
                    }
                }
                break
            }
        }
        sudoku[row][column] = 0
        return false
    }

    func hollowOutSudoku() {
        var attempts = 1 //difficulty
        counter = 1
        while attempts > 0 {
            var numberList: [Int] = []
            for count in 0...80 {
                numberList.append(count)
            }
            numberList.shuffle()
            for index in numberList {
                let row = index / 9
                let column = index % 9
                let backup = sudoku[row][column]
                sudoku[row][column] = 0
                let copySudoku: [[Int]] = sudoku
                
                counter = 0
                if solveSudoku(sudoku: copySudoku) && counter != 1 {
                    sudoku[row][column] = backup
                    attempts -= 1
                    break;
                }
            }
            attempts -= 1
        }
    }
}
