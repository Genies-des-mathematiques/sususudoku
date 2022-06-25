//
//  Scoreboard.swift
//  sususudoku
//
//  Created by TeU on 2022/6/25.
//

import FirebaseFirestoreSwift
import Foundation

struct GameRecord: Equatable, Identifiable, Codable {
    @DocumentID var id: String?
    let score: Int
    let gameTime: TimeInterval
}
