//
//  SettingSheet.swift
//  sususudoku
//
//  Created by TeU on 2022/6/17.
//

import SwiftUI

struct SettingSheet: View {
    @Environment(\.dismiss) private var _dismiss

    var body: some View {
        List {
            Section {
                SettingItem(iconName: "gearshape", itemName: "設定", iconColor: .red)
                SettingItem(iconName: "graduationcap", itemName: "遊玩方式", iconColor: .orange)
            }
            Section {
                SettingItem(iconName: "info.circle", itemName: "關於遊戲", iconColor: .blue)
                SettingItem(iconName: "questionmark.circle", itemName: "幫助", iconColor: .green)
            }
        }
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("選項")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    _dismiss()
                }
            }
        }
        .background(Color("AppBackground"))
    }
}

#if DEBUG
struct SettingSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingSheet()
    }
}
#endif
