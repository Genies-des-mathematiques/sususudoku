//
//  GameBoardViewModel.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/22.
//

import Foundation

class GameBoardViewModel {
    private let _puzzle: Puzzle

    private let _difficulty: Difficulty
    var difficulty: Difficulty { return _difficulty }
    private var _gameStatus: GameStatus
    var gameStatus: GameStatus { return _gameStatus }

    var blockRowCount: Int { return _puzzle.rowCount }
    var blockColumnCount: Int { return _puzzle.columnCount }
    var boardEdgeCount: Int { return _puzzle.edgeCount }

    init(_ rowCount: Int, _ columnCount: Int, _ difficulty: Difficulty, _ gameStatus: GameStatus) {
        _puzzle = Puzzle(rowCount, columnCount)
        _difficulty = difficulty
        _gameStatus = gameStatus
    }

    func getCellText(rowIndex: Int, columnIndex: Int) -> String {
        let value = _puzzle.getNumber(rowIndex: rowIndex, columnIndex: columnIndex)
        return value == 0 ? "" : "\(value)"
    }
}
