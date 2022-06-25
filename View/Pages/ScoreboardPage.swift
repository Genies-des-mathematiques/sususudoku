//
//  ScoreboardPage.swift
//  sususudoku
//
//  Created by Ricky Hu on 2022/6/25.
//

import SwiftUI
import UIPilot

struct ScoreboardPage: View {
    @State private var _isShowingSettingSheet = false
    @EnvironmentObject private var _pilot: UIPilot<AppRoute>

    var body: some View {
        VStack {
            GeometryReader { _ in
                ZStack {
                    Circle().strokeBorder(.clear, lineWidth: 0)
                    VStack {
                        ScrollView(.vertical) {
                            ForEach(1 ... 50, id: \.self) { index in
                                HStack(spacing: 20) {
                                    let _rankText = "\(index)"
                                    let _nameText = "abcdefghijklmnopqrstuvwxyz"
                                    let _timeText = "01:00:00"
                                    Text(_rankText)
                                        .font(.title2)
                                        .fontWeight(.black)
                                        .frame(width: 40, height: 24, alignment: .center)
                                    Text(_nameText)
                                        .frame(width: 200, height: 24, alignment: .leading)
                                    Text(_timeText)
                                        .frame(width: 80, height: 24, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity)
                                .padding([.vertical], 8)
                            }
                        }
                        .padding([.bottom], 60)
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Scoreboard")
                    .font(.title)
                    .fontWeight(.black)
            }
            ToolbarItem {
                Button {
                    _isShowingSettingSheet = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
        .sheet(isPresented: $_isShowingSettingSheet) {
            NavigationView {
                SettingSheet()
            }
        }
        .background(Color("AppBackground"))
    }
}

#if DEBUG
struct ScoreboardPage_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardPage()
    }
}
#endif
