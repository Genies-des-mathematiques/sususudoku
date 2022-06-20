//
//  GameBoard.swift
//  TryGameBoard
//
//  Created by 郭梓琳 on 2022/6/11.
//

import SwiftUI

struct GameBoardView: View {
    private let _columnCount: Int
    private let _rowCount: Int
    private let _size: Int
    private let _difficulty: Difficulty
    private let _gameStart = GameStatus(status: "Play", displayIconName: "pause")
    private let _gamePause = GameStatus(status: "Pause", displayIconName: "play.fill")

    private var _gameStatus: GameStatus
    private var _hintLeft = 3

    init(_ columnCount: Int, _ rowCount: Int, _ difficulty: Difficulty) {
        _columnCount = columnCount
        _rowCount = rowCount
        _size = _columnCount * _rowCount
        _difficulty = difficulty
        _gameStatus = _gameStart
    }

    var body: some View {
        VStack {
            TopBar()

            GameGrid(_difficulty, _columnCount, _rowCount, _gameStatus, Grid())

            // game buttons
            HStack {
                Spacer()
                // delete button
                Button {} label: {
                    VStack {
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("GameButton"))
                        Text("清除")
                            .foregroundColor(Color("GameButton"))
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
                            .foregroundColor(Color("GameButton"))
                        Text("筆記")
                            .foregroundColor(Color("GameButton"))
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
                                .foregroundColor(Color("GameButton"))
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("AppBackground"))
                                .padding(.bottom, 12)
                                .padding(.leading, 18)
                            Image(systemName: "\(_hintLeft).circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("AppButton"))
                                .padding(.bottom, 12)
                                .padding(.leading, 18)
                        }

                        Text("提示")
                            .foregroundColor(Color("GameButton"))
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
                ForEach(1 ... _size, id: \.self) { number in
                    Button {} label: {
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(Color("AppButton"))
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

struct TopBar: View {
    var body: some View {
        HStack {
            // back button
            Button {} label: {
                VStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("AppButton"))
                }
            }
            Spacer()

            // app title label
            Text(Constants.appTitle)
                .font(.title)
                .bold()
                .foregroundColor(Color("AppTitle"))
            Spacer()

            // settings button
            Button {} label: {
                VStack {
                    Image(systemName: "gearshape")
                        .foregroundColor(Color("AppButton"))
                }
            }
        }
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}

struct GameGrid: View {
    private let _difficulty: Difficulty
    private let _columnCount: Int
    private let _rowCount: Int
    private var _gameStatus: GameStatus
    private let _grid: Grid
    private let _size: Int
    private let _cellSize: Double

    init(_ difficulty: Difficulty, _ columnCount: Int, _ rowCount: Int, _ gameStatus: GameStatus, _ grid: Grid) {
        _difficulty = difficulty
        _columnCount = columnCount
        _rowCount = rowCount
        _gameStatus = gameStatus
        _grid = grid
        _size = _columnCount * _rowCount
        _cellSize = Double(UIScreen.screenWidth) / Double(_size)
    }

    var body: some View {
        VStack {
            // game status
            HStack {
                Text(_difficulty.rawValue)
                Spacer()

                // pause and play button
                Button {} label: {
                    VStack {
                        Image(systemName: _gameStatus.displayIcon())
                            .foregroundColor(Color("GameButton"))
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)

            // sudoku grid
            ZStack {
                // fill grid value
                VStack(spacing: -1) {
                    ForEach(0 ..< _size, id: \.self) { row in
                        HStack(spacing: -1) {
                            ForEach(0 ..< _size, id: \.self) { col in
                                Text("\(_grid.render(rowIndex: row, columnIndex: col))")
                                    .font(.title)
                                    .foregroundColor(Color("AppNumber"))
                                    .frame(width: _cellSize, height: _cellSize)
                                    .border(.gray, width: 1)
                                    .padding(.all, 0)
                            }
                        }
                    }
                }

                // draw grid outline
                VStack(spacing: -1) {
                    ForEach(0 ..< _columnCount, id: \.self) { _ in
                        HStack(spacing: -1) {
                            ForEach(0 ..< _rowCount, id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(Color("AppBackground").opacity(0))
                                    .frame(
                                        width: _cellSize * Double(_columnCount) - 1,
                                        height: _cellSize * Double(_rowCount) - 1)
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

struct GameStatus {
    private let _status: String
    private let _displayIconName: String

    init(status: String, displayIconName: String) {
        _status = status
        _displayIconName = displayIconName
    }

    func displayIcon() -> String {
        return _displayIconName
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(3, 3, Difficulty.Easy)
    }
}
