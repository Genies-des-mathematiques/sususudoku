//
//  GameBoard.swift
//  TryGameBoard
//
//  Created by 郭梓琳 on 2022/6/11.
//

import SwiftUI

struct GameBoardView: View {
    private let appTitle = "SuSuSudoku"
    private let screenWidth = 380
    private let columnCount = 3
    private let rowCount = 3
    private let difficulty = Difficulty.Easy

    private var gameStatus = GameStatus.Pause
    private var hintLeft = 3

    var body: some View {
        let size = columnCount * rowCount

        VStack {
            TopBar(appTitle: appTitle)

            GameGrid(difficulty: difficulty, gameStatus: gameStatus, screenWidth: screenWidth, columnCount: columnCount, rowCount: rowCount)

            // game buttons
            HStack {
                Spacer()
                // delete button
                Button {} label: {
                    VStack {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                        Text("清除")
                            .foregroundColor(Color(.label))
                            .font(.footnote)
                    }
                }
                Spacer()

                // note button
                Button {} label: {
                    VStack {
                        Image(systemName: "pencil.tip")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                        Text("筆記")
                            .foregroundColor(Color(.label))
                            .font(.footnote)
                    }
                }
                Spacer()

                // hint button
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
                Spacer()
            }
            .frame(height: 50)
            .padding(.top)
            .padding(.bottom)

            // number buttons
            HStack {
                Spacer()
                ForEach(1 ... size, id: \.self) { number in
                    Button {} label: {
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(Colors.DarkBlue)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.Background)
    }
}

struct TopBar: View {
    let appTitle: String

    var body: some View {
        HStack {
            // back button
            Button {} label: {
                VStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Colors.DarkBlue)
                }
            }
            Spacer()

            // app title lable
            Text("\(appTitle)")
                .font(.title)
                .bold()
                .foregroundColor(Colors.DarkBlue)
            Spacer()

            // settings button
            Button {} label: {
                VStack {
                    Image(systemName: "gearshape")
                        .foregroundColor(Colors.DarkBlue)
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}

struct GameGrid: View {
    let difficulty: Difficulty
    let gameStatus: GameStatus
    let screenWidth: Int
    let columnCount: Int
    let rowCount: Int
    let grid = Grid.init()

    var body: some View {
        let size = columnCount * rowCount
        let cellSize = Double(screenWidth) / Double(size)

        VStack {
            // game status
            HStack {
                Text(difficulty.rawValue)
                Spacer()

                // pause and play button
                Button {} label: {
                    VStack {
                        Image(systemName: gameStatus.rawValue)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)

            // sudoku grid
            ZStack {
                // fill grid value
                VStack(spacing: -1) {
                    ForEach(0 ..< size, id: \.self) { row in
                        HStack(spacing: -1) {
                            ForEach(0 ..< size, id: \.self) { col in
                                self.grid.render(row: row, col: col)
                                    .frame(width: cellSize, height: cellSize)
                                    .border(.gray, width: 1)
                                    .padding(.all, 0)
                            }
                        }
                    }
                }

                // draw grid outline
                VStack(spacing: -1) {
                    ForEach(0 ..< columnCount, id: \.self) { _ in
                        HStack(spacing: -1) {
                            ForEach(0 ..< rowCount, id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(Colors.Background.opacity(0))
                                    .frame(width: cellSize * Double(columnCount) - 1, height: cellSize * Double(rowCount) - 1)
                                    .border(.black, width: 1.5)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

enum GameStatus: String, CaseIterable {
    case Pause = "pause"
    case Play = "play.fill"
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
