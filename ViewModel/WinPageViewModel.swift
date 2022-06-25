//
//  WinPageViewModel.swift
//  sususudoku
//
//  Created by TeU on 2022/6/25.
//

import Foundation

struct WinPageViewModel {
    private let _gameRecordStore = CreateGameRecordStore()

    func saveGameRecord(gameTimeInSeconds: Int, playerName: String) -> Bool {
        let record = GameRecord(name: playerName, gameTimeInSeconds: gameTimeInSeconds)
        return _gameRecordStore.saveNewRecord(record)
    }
}
