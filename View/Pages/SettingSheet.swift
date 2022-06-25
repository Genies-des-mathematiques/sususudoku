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
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.blue)
                    NavigationLink("About") {
                        TermsOfService()
                    }
                }

                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.green)
                    Link(destination: URL(string: "https://sudoku.com/sudoku-rules/")!, label: {
                        Text("Support")
                            .foregroundColor(.black)
                    })
                }
            }
        }
        .listStyle(GroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Options")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
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
