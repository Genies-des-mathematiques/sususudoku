//
//  GameStatus.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/22.
//

import Foundation

struct GameStatus {
    private let _status: String
    private let _displayIconName: String
    var displayIconName: String { return _displayIconName }
    
    init(status: String, displayIconName: String) {
        _status = status
        _displayIconName = displayIconName
    }
}
