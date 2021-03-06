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
    @State private var _isShowingSettingSheet = false
    @State private var _showSafeSuccessAlert = false
    @State private var _showNoNameAlert = false
    @EnvironmentObject private var _pilot: UIPilot<AppRoute>

    private let _viewModel = WinPageViewModel()

    let timeInSeconds: Int

    var body: some View {
        VStack {
            Text("Congratulations!!!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(10)

            VStack {
                Text("Cost Time")
                Text(timeInSeconds.toTimeString())
                    .fontWeight(.bold)
            }
            .padding(10)

            VStack {
                Text("Please text in your name")
                TextField("Your Name", text: $_name, prompt: Text("YourName"))
                    .frame(width: UIScreen.screenWidth - 60, height: 30)
                    .padding(10)
                    .cornerRadius(40)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.blue, lineWidth: 3))
            }
            .padding(10)

            Button {
                if !_name.trim().isEmpty {
                    _showSafeSuccessAlert = _viewModel.saveGameRecord(gameTimeInSeconds: timeInSeconds, playerName: _name.trim())
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
                Text("Your name: " + _name.trim() + "\nCost time: " + timeInSeconds.toTimeString())
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
        .navigationBarBackButtonHidden(true)
    }
}

#if DEBUG
struct WinPage_Previews: PreviewProvider {
    static var previews: some View {
        WinPage(timeInSeconds: 0)
    }
}
#endif
