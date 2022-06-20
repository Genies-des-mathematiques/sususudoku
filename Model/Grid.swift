//
//  Grid.swift
//  sususudoku
//
//  Created by 郭梓琳 on 2022/6/14.
//

import Foundation

final class Grid {
    private var grid: [[Int]]

    let sudokuAnswer = [
        [4, 6, 7, 1, 5, 8, 3, 2, 9],
        [5, 9, 1, 7, 3, 2, 8, 4, 6],
        [3, 2, 8, 4, 6, 9, 7, 5, 1],
        [1, 4, 6, 5, 2, 3, 9, 8, 7],
        [9, 3, 2, 8, 4, 7, 6, 1, 5],
        [8, 7, 5, 9, 1, 6, 4, 3, 2],
        [6, 8, 4, 2, 9, 1, 5, 7, 3],
        [2, 5, 9, 3, 7, 4, 1, 6, 8],
        [7, 1, 3, 6, 8, 5, 2, 9, 4]
    ]
    let sudoku = [
        [0, 6, 7, 0, 5, 0, 0, 0, 0],
        [0, 0, 0, 0, 3, 2, 8, 4, 0],
        [3, 2, 0, 4, 0, 0, 7, 5, 0],
        [0, 0, 6, 0, 0, 0, 0, 0, 7],
        [0, 0, 2, 8, 0, 0, 0, 0, 0],
        [8, 0, 0, 0, 1, 6, 0, 0, 2],
        [0, 8, 0, 2, 9, 0, 5, 7, 3],
        [0, 0, 0, 3, 0, 4, 1, 0, 8],
        [0, 1, 0, 0, 0, 0, 0, 0, 4]
    ]

    init() {
        self.grid = sudoku
//        self.grid = sudokuAnswer
    }

    func render(rowIndex: Int, columnIndex: Int) -> Int {
        return grid[rowIndex][columnIndex]
    }
}

enum Difficulty: String, CaseIterable {
    case Easy = "簡單"
    case Medium = "中等"
    case Hard = "困難"
    case Expert = "專家"
}