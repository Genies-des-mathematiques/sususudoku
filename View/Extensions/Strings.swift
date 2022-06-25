//
//  Strings.swift
//  sususudoku
//
//  Created by TeU on 2022/6/25.
//

import Foundation

extension String {
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
