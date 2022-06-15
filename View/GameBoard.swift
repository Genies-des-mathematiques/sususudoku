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
    private var cellSize: Double = 380 / 9

    private var hintLeft: Int = 3

    var body: some View {
        VStack {
            ZStack {
                gameGrid
                drawGridOutline
            }
            HStack {
                Spacer()
                deleteButton
                Spacer()
                noteButton
                Spacer()
                hintButton
                Spacer()
            }
            .frame(height: 55)
            .padding()
            numberButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.Background)
    }

    private var gameGrid: some View {
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
            ForEach(0 ..< n) { _ in
                HStack(spacing: -1) {
                    ForEach(0 ..< m) { _ in
                        Rectangle()
                            .foregroundColor(Colors.Background.opacity(0))
                            .frame(width: cellSize * Double(n) - 1, height: cellSize * Double(m) - 1)
                            .border(.black, width: 1.5)
                    }
                }
            }
        }
    }

    private var deleteButton: some View {
        Button {} label: {
            VStack {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                Text("清除")
                    .foregroundColor(Color(.label))
                    .font(.footnote)
            }
        }
    }

    private var noteButton: some View {
        Button {} label: {
            VStack {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                Text("筆記")
                    .foregroundColor(Color(.label))
                    .font(.footnote)
            }
        }
    }

    private var hintButton: some View {
        Button {} label: {
            VStack {
                ZStack {
                    Image(systemName: "lightbulb")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding(.bottom, 12)
                        .padding(.leading, 18)
                    Image(systemName: "\(hintLeft).circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Colors.DarkBlue)
                        .padding(.bottom, 12)
                        .padding(.leading, 18)
                }

                Text("提示")
                    .foregroundColor(Color(.label))
                    .font(.footnote)
            }
        }
    }

    private var numberButtons: some View {
        HStack {
            Spacer()
            ForEach(1 ... columnCount, id: \.self) { number in
                Button {} label: {
                    Text("\(number)")
                        .font(.largeTitle)
                        .foregroundColor(Colors.DarkBlue)
                }
                Spacer()
            }
        }
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
