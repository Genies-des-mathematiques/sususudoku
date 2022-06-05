//
//  ContentView.swift
//  sususudoku
//
//  Created by TeU on 2022/6/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            Button("Crash") {
                fatalError("Crash was triggered")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
