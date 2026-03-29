//
//  NoteSyncApp.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI
import FirebaseCore

@main
struct NoteSyncApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            MainView(isAuthenticated: authViewModel.isAuthenticated)
                .preferredColorScheme(.dark)
        }
        .environmentObject(authViewModel)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
