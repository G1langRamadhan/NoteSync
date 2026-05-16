//
//  NoteSyncApp.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI

@main
struct NoteSyncApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            MainView(authState: authViewModel.authState)
                .preferredColorScheme(.dark)
                .environmentObject(authViewModel)
        }
    }
}
