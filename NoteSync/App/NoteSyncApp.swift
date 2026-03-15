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
    var body: some Scene {
        WindowGroup {
//            ContentView()
//           LoginView()
            NoteListView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
