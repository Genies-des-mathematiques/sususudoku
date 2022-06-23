//
//  GameBoard.swift
//  TryGameBoard
//
//  Created by 郭梓琳 on 2022/6/11.
//

import SwiftUI

struct GameBoardPage: View {
    @State private var _isShowingSettingSheet = false

    private let _rowCount: Int
    private let _columnCount: Int
    var edgeCount: Int { return _rowCount * _columnCount }

    private let _difficulty: Difficulty
    private let _gameStart = GameStatus(status: "Play", displayIconName: "pause")
    private let _gamePause = GameStatus(status: "Pause", displayIconName: "play.fill")

    private var _gameStatus: GameStatus
    private var _hintLeft = 3

    init(_ columnCount: Int, _ rowCount: Int, _ difficulty: Difficulty) {
        _columnCount = columnCount
        _rowCount = rowCount
        _difficulty = difficulty
        _gameStatus = _gameStart
    }

    var body: some View {
        VStack {
            GameGrid(_rowCount, _columnCount, _difficulty, _gameStatus)

            // game buttons
            HStack {
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
                .frame(maxWidth: .infinity)

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
                .frame(maxWidth: .infinity)

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
                .frame(maxWidth: .infinity)
            }
            .frame(height: 50)

            // number buttons
            HStack {
                ForEach(1 ... edgeCount, id: \.self) { number in
                    Button {} label: {
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(Color("AppButton"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // need a spacer to push everything to the top
            Spacer()
        }
        .toolbar {
            // app title label
            ToolbarItem(placement: .principal) {
                Text(Constants.appTitle)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color("AppTitle"))
                    .frame(maxWidth: .infinity)
            }
            // settings button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    _isShowingSettingSheet = true
                } label: {
                    VStack {
                        Image(systemName: "gearshape")
                            .foregroundColor(Color("AppButton"))
                    }
                }
                .sheet(isPresented: $_isShowingSettingSheet) {
                    NavigationView {
                        SettingSheet()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

struct GameGrid: View {
    private let _cellSize: Double
    private let _viewModel: GameBoardViewModel

    init(_ rowCount: Int, _ columnCount: Int, _ difficulty: Difficulty, _ gameStatus: GameStatus) {
        _viewModel = GameBoardViewModel(rowCount, columnCount, difficulty, gameStatus)
        _cellSize = Double(UIScreen.screenWidth) / Double(_viewModel.boardEdgeCount)
    }

    var body: some View {
        VStack {
            // game status
            HStack {
                Text(_viewModel.difficulty.rawValue)

                // need a spacer to push the elements aside
                Spacer()

                // pause and play button
                Button {} label: {
                    VStack {
                        Image(systemName: _viewModel.gameStatus.displayIconName)
                            .foregroundColor(Color("GameButton"))
                    }
                }
            }
            .padding(.horizontal)

            // sudoku grid
            ZStack {
                // fill grid value
                VStack(spacing: -1) {
                    ForEach(0 ..< _viewModel.boardEdgeCount, id: \.self) { rowIndex in
                        HStack(spacing: -1) {
                            ForEach(0 ..< _viewModel.boardEdgeCount, id: \.self) { columnIndex in
                                Text(_viewModel.getCellText(rowIndex: rowIndex, columnIndex: columnIndex))
                                    .font(.title)
                                    .foregroundColor(Color("AppNumber"))
                                    .frame(width: _cellSize, height: _cellSize)
                                    .border(Color("GameGridLine"), width: 1)
                            }
                        }
                    }
                }

                // draw grid outline
                VStack(spacing: -1) {
                    ForEach(0 ..< _viewModel.blockColumnCount, id: \.self) { _ in
                        HStack(spacing: -1) {
                            ForEach(0 ..< _viewModel.blockRowCount, id: \.self) { _ in
                                Rectangle()
                                    .foregroundColor(Color("AppBackground").opacity(0))
                                    .frame(
                                        width: _cellSize * Double(_viewModel.blockColumnCount) - 1,
                                        height: _cellSize * Double(_viewModel.blockRowCount) - 1)
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

#if DEBUG
struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardPage(3, 3, Difficulty.Easy)
    }
}
#endif