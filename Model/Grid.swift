//
//  Grid.swift
//  sususudoku
//
//  Created by 郭梓琳 on 2022/6/14.
//

import Foundation
import SwiftUI

final class Grid: ObservableObject {
    @Published private var grid: [[Int]] = .init()
    let systemNumberColor = Color(red: 86 / 255, green: 63 / 255, blue: 46 / 255)

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
//        self.grid = Array(
//            repeating: Array(repeating: 0, count: 9),
//            count: 9
//        )
        self.grid = sudoku
//        self.grid = sudokuAnswer
    }
    
    func render(row: Int, col: Int) -> Text {
        let value: Int = grid[row][col]
        
        if value == 0 {
            return Text("")
        }

        return Text("\(value)")
            .font(.title)
            .foregroundColor(systemNumberColor)
    }
}
