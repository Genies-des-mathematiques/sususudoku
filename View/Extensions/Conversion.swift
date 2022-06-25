//
//  Conversion.swift
//  sususudoku
//
//  Created by 郭梓琳 on 2022/6/25.
//

import Foundation

extension Int {
    func toTimeString() -> String {
        if self < 0 {
            return "--:--"
        }

        let minutes = self / 60
        let seconds = self % 60

        if self < 3600 {
            return String(format: "%02i:%02i", minutes, seconds)
        }

        let hours = minutes / 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
