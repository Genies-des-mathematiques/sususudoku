//
//  WinPage.swift
//  sususudoku
//
//  Created by Eddie on 2022/6/25.
//

import SwiftUI
import UIPilot

struct WinPage: View {
    @State private var _name = ""
    @State private var _costTimeString = "01:02:03"
    @State private var _isShowingSettingSheet = false
    @State private var _showSafeSuccessAlert = false
    @State private var _showNoNameAlert = false
    @EnvironmentObject private var _pilot: UIPilot<AppRoute>

    var body: some View {
        VStack {
            Text("Congratulation!!!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10)

            VStack {
                Text("Cost Time")
                Text(_costTimeString)
                    .fontWeight(.bold)
            }
            .padding(10)

            VStack {
                Text("Please text in your name")
                TextField("Your Name", text: $_name, prompt: Text("YourName"))
                    .frame(width: UIScreen.screenWidth - 60, height: 40)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.blue, lineWidth: 3))
            }
            .padding(10)

            Button {
                // TODO: record the name and cost time
                if !_name.trim().isEmpty {
                    _showSafeSuccessAlert = true
                } else {
                    _showNoNameAlert = true
                }
            } label: {
                Text("Submit")
                    .padding(5)
            }
            .alert("Save Success", isPresented: $_showSafeSuccessAlert, actions: {
                Button("Back to main page") {
                    _pilot.popTo(.HomePage)
                }
            }, message: {
                Text("Your name: " + _name.trim() + "\nCost time: " + _costTimeString)
            })
            .alert("Alert", isPresented: $_showNoNameAlert, actions: {
                Button("OK") {}
            }, message: {
                Text("Oh no. Your name is empty.\nPlease correct your name and try again.")
            })
            .buttonStyle(ActivityButtonStyle())
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(10)
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

#if DEBUG
struct WinPage_Previews: PreviewProvider {
    static var previews: some View {
        WinPage()
    }
}
#endif
