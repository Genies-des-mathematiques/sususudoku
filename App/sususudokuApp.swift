//
//  sususudokuApp.swift
//  sususudoku
//
//  Created by TeU on 2022/6/5.
//

import FirebaseCore
import SwiftUI
import UIPilot

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        return true
    }
}

enum AppRoute: Equatable {
    case HomePage
    case GameBoardPage
    case WinPage(timeInSeconds: Int)
    case ScoreboardPage
}

@main
struct sususudokuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var _pilot = UIPilot(initial: AppRoute.HomePage)

    var body: some Scene {
        WindowGroup {
            UIPilotHost(_pilot) { route in
                switch route {
                case .HomePage:
                    return AnyView(
                        HomePage()
                    )
                case .GameBoardPage:
                    return AnyView(
                        GameBoardPage(3, 3, Difficulty.Easy)
                    )
                case .WinPage(let timeInSeconds):
                    return AnyView(
                        WinPage(timeInSeconds: timeInSeconds)
                case .ScoreboardPage:
                    return AnyView(
                        ScoreboardPage()
                    )
                }
            }
        }
    }
}
