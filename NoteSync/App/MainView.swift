//
//  MainView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct MainView: View {
    @StateObject var authViewModel = AuthViewModel()
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                ContainerTabView()
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    MainView()
}
