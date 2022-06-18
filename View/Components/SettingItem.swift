//
//  SettingItem.swift
//  sususudoku
//
//  Created by TeU on 2022/6/17.
//

import SwiftUI

struct SettingItem: View {
    let iconName: String
    let itemName: String
    let iconColor: Color

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            NavigationLink(itemName) {}
        }
    }
}

#if DEBUG
struct SettingItem_Previews: PreviewProvider {
    static var previews: some View {
        SettingItem(iconName: "gearshape", itemName: "設定", iconColor: .red)
            .previewLayout(.sizeThatFits)
    }
}
#endif
