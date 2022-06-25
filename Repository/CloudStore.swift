//
//  ScoreboardStore.swift
//  sususudoku
//
//  Created by TeU on 2022/6/25.
//

import Firebase
import Foundation
import os

protocol GameRecordStore {
    func saveNewRecord(_ newRecord: GameRecord) -> Bool
    func loadAllRecords() async -> [GameRecord]
}

func CreateGameRecordStore() -> GameRecordStore {
    _GameRecordStoreImpl(store: .firestore(), logger: .init())
}

private struct _GameRecordStoreImpl: GameRecordStore {
    private let _store: Firestore
    private let _gameRecordCollectionPath = "game-record"
    private let _logger: Logger

    init(store: Firestore, logger: Logger) {
        _store = store
        _logger = logger
    }

    private var _collection: CollectionReference {
        _store.collection(_gameRecordCollectionPath)
    }

    func saveNewRecord(_ newRecord: GameRecord) -> Bool {
        do {
            _ = try _collection.addDocument(from: newRecord)
            return true
        } catch {
            _logger.error("\(error.localizedDescription)")
            return false
        }
    }

    @MainActor
    func loadAllRecords() async -> [GameRecord] {
        guard let snapshot = try? await _collection.getDocuments() else { return [] }
        return snapshot.documents.compactMap { doc in
            try? doc.data(as: GameRecord.self)
        }
    }
}
