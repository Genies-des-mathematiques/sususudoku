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
        VStack {
            Text("HIHIHI")
        }
        .toolbar{
            ToolbarItem (placement: .cancellationAction) {
                Button("Cancel") {
                    _dismiss()
                }
            }
        }
    }
}

#if DEBUG
struct SettingSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingSheet()
    }
}
#endif
