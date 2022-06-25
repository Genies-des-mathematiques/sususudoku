//
//  ScoreboardViewModel.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/25.
//

import Foundation

class ScoreboardViewModel: ObservableObject {
    private let _gameRecordStore: GameRecordStore
    @Published private var _records: [GameRecord] = []

    var recordsCount: Int { _records.count }

    init() {
        _gameRecordStore = CreateGameRecordStore()
        loadRecords()
    }

    func loadRecords() {
        Task {
            _records = await _gameRecordStore.loadAllRecords()
            _records = _records.sorted { $0.gameTimeInSeconds < $1.gameTimeInSeconds }
        }
    }

    func getRecordRank(_ index: Int) -> String {
        return "\(index + 1)"
    }

    func getRecordName(_ index: Int) -> String {
        return _records[index].name
    }

    func getRecordTimeText(_ index: Int) -> String {
        return _records[index].gameTimeInSeconds.toTimeString()
    }
}
