//
//  Scoreboard.swift
//  sususudoku
//
//  Created by TeU on 2022/6/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct GameRecord: Equatable, Identifiable, Codable {
    @DocumentID private(set) var id: String?
    @ServerTimestamp private(set) var createdAt: Timestamp?
    let name: String
    let gameTimeInSecond: Int
}
