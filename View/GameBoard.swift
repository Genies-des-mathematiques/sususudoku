//
//  GameBoard.swift
//  TryGameBoard
//
//  Created by 郭梓琳 on 2022/6/11.
//

import SwiftUI

struct GameBoardView: View {
    //    @EnvironmentObject var grid: Grid
    private var n: Int = 3
    private var m: Int = 3
    private var columnCount: Int = 9
    private var grid: Grid = .init()
    private var cellSize: Double = 360 / 9

    let backgroundColor = Color(red: 241 / 255, green: 234 / 255, blue: 220 / 255)
    let numberColor = Color(red: 72 / 255, green: 95 / 255, blue: 155 / 255)

    var body: some View {
        VStack {
            ZStack {
                renderGameGrid
                drawGridOutline
            }
            renderNumberButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }

    private var renderGameGrid: some View {
        VStack(spacing: -1) {
            ForEach(0 ..< columnCount) { row in
                HStack(spacing: -1) {
                    ForEach(0 ..< columnCount) { col in
                        self.grid.render(row: row, col: col)
                            .frame(width: cellSize, height: cellSize)
                            .border(.gray, width: 1)
                            .padding(.all, 0)
                    }
                }
            }
        }
    }

    private var drawGridOutline: some View {
        VStack(spacing: -1) {
            ForEach(0 ..< n) { row in
                HStack(spacing: -1) {
                    ForEach(0 ..< m) { col in
                        Rectangle()
                            .foregroundColor(backgroundColor.opacity(0))
                            .frame(width: cellSize * Double(n) - 1, height: cellSize * Double(m) - 1)
                            .border(.black, width: 1.5)
                    }
                }
            }
        }
    }

    private var renderNumberButtons: some View {
        HStack {
            ForEach(1 ... columnCount, id: \.self) { number in
                Button {} label: {
                    Text("\(number)")
                        .font(.largeTitle)
                        .foregroundColor(numberColor)
                }
            }
        }
        .padding()
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
