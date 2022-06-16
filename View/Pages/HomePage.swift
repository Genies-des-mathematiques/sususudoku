//
//  HomePage.swift
//  sususudoku
//
//  Created by TeU on 2022/6/15.
//

import SwiftUI

struct HomePage: View {
    @State private var _isShowingSettingSheet = false

    var body: some View {
        VStack {
            GeometryReader { g in
                ZStack {
                    Circle().strokeBorder(.clear, lineWidth: 0)
                    VStack {
                        Text("SuSuSudoku")
                            .font(.system(size: g.size.height > g.size.width ? g.size.width * 0.1 : g.size.height * 0.1))
                            .fontWeight(.black)
                        Button {} label: {
                            Text("新遊戲")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(ActivityButtonStyle())
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .padding()
            }
        }
        .toolbar {
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
        .ignoresSafeArea()
    }
}

#if DEBUG
struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
#endif
