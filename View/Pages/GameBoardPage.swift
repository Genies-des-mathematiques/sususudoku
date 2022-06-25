//
//  GameBoard.swift
//  TryGameBoard
//
//  Created by 郭梓琳 on 2022/6/11.
//

import SwiftUI
import UIPilot

struct GameBoardPage: View {
    @State private var _isShowingSettingSheet = false
    @State private var _showAlert = false
    @EnvironmentObject private var _pilot: UIPilot<AppRoute>

    @ObservedObject private var _viewModel: GameBoardViewModel

    init(_ columnCount: Int, _ rowCount: Int, _ difficulty: Difficulty) {
        _viewModel = GameBoardViewModel(rowCount, columnCount, difficulty)
        _viewModel.startTimer()
    }

    var body: some View {
        VStack {
            GameGrid(_viewModel)

            // game buttons
            HStack {
                // delete button
                Button {
                    _viewModel.clearCellNumber()
                } label: {
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
                .disabled(!_viewModel.isTimerCounting)
                .frame(maxWidth: .infinity)

                // note button
                Button {
                    _viewModel.toggleNoteMode()
                } label: {
                    VStack {
                        let _color = _viewModel.isNoteMode ? Color("AppButton") : Color("GameButton")
                        Image(systemName: "pencil.tip")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(_color)
                        Text("筆記")
                            .foregroundColor(_color)
                            .font(.footnote)
                    }
                }
                .disabled(!_viewModel.isTimerCounting)
                .frame(maxWidth: .infinity)

                // hint button
                Button {
                    _viewModel.useHint()
                } label: {
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
                            Image(systemName: "\(_viewModel.hints).circle.fill")
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
                .disabled(!_viewModel.isTimerCounting)
                .disabled(!_viewModel.canUseHints)
                .frame(maxWidth: .infinity)
            }
            .frame(height: 50)

            // number buttons
            HStack {
                ForEach(1 ... _viewModel.boardEdgeCount, id: \.self) { number in
                    Button {
                        _viewModel.fillCellNumber(value: number)
                    } label: {
                        Text("\(number)")
                            .font(.largeTitle)
                            .foregroundColor(Color("AppButton"))
                    }
                    .disabled(!_viewModel.isTimerCounting)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // send and validate board button
            Button {
                if _viewModel.isBoardValid {
                    _viewModel.pauseTimer()
                    _pilot.push(.WinPage(timeInSeconds: _viewModel.timeInSeconds))
                } else {
                    _showAlert = true
                }
            } label: {
                Text("送出")
                    .foregroundColor(.white)
            }
            .alert("Failed", isPresented: $_showAlert, actions: {
                Button("Continue") {}
            }, message: {
                Text("Oh no. Your sudoku answer is worng. \nPlease correct your answers and try again.")
            })
            .disabled(!_viewModel.isTimerCounting)
            .disabled(!_viewModel.isBoardCompleted)
            .buttonStyle(ActivityButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity)

            // need a spacer to push everything to the top
            Spacer()

            Button {
                _viewModel.revealAnswer()
            } label: {
                Text("Copyright © 2022 SuSuSudoku Ltd,.")
                    .font(.caption)
                    .foregroundColor(Color("AppTitle"))
            }
            .disabled(!_viewModel.isTimerCounting)
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
    @ObservedObject private var _viewModel: GameBoardViewModel

    init(_ viewModel: GameBoardViewModel) {
        _viewModel = viewModel
        _cellSize = Double(UIScreen.screenWidth) / Double(viewModel.boardEdgeCount)
    }

    var body: some View {
        VStack {
            // game status
            HStack {
                Text(_viewModel.timeInSeconds.toTimeString())

                // need a spacer to push the elements aside
                Spacer()

                // pause and play button
                Button {
                    _viewModel.isTimerCounting ? _viewModel.pauseTimer() : _viewModel.startTimer()
                } label: {
                    VStack {
                        Image(systemName: _viewModel.gameStatus.displayIconName)
                            .foregroundColor(Color("GameButton"))
                    }
                }
            }
            .padding(.horizontal)

            // sudoku grid
            ZStack {
                if !_viewModel.isTimerCounting {
                    Text("Paused")
                        .font(.largeTitle)
                        .foregroundColor(Color("AppNumber"))
                        .frame(width: UIScreen.screenWidth, height: UIScreen.screenWidth)
                } else {
                    // fill grid value
                    VStack(spacing: -1) {
                        ForEach(0 ..< _viewModel.boardEdgeCount, id: \.self) { rowIndex in
                            HStack(spacing: -1) {
                                ForEach(0 ..< _viewModel.boardEdgeCount, id: \.self) { columnIndex in
                                    Button {
                                        _viewModel.selectCell(rowIndex: rowIndex, columnIndex: columnIndex)
                                    } label: {
                                        let _cellColor = _viewModel.isSelectedCell(rowIndex: rowIndex, columnIndex: columnIndex) ? Color("SelectedCell") : Color("CellBackground")
                                        let _textColor = _viewModel.isPuzzleCell(rowIndex: rowIndex, columnIndex: columnIndex) ? Color("AppButton") : Color("AppNumber")
                                        let _isShowingNotes = _viewModel.isShowingNotes(rowIndex: rowIndex, columnIndex: columnIndex)
                                        let _text = _viewModel.getCellText(rowIndex: rowIndex, columnIndex: columnIndex)
                                        Text(_text)
                                            .font(_isShowingNotes ? Font.body : Font.title)
                                            .foregroundColor(_isShowingNotes ? Color("NoteNumber") : _textColor)
                                            .frame(width: _cellSize, height: _cellSize)
                                            .scaledToFill()
                                            .minimumScaleFactor(_isShowingNotes ? 0.5 : 1)
                                            .background(_cellColor)
                                            .border(Color("GameGridLine"), width: 1)
                                    }
                                    .frame(maxWidth: .infinity)
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
