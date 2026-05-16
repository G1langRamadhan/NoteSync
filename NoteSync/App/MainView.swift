//
//  MainView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct MainView: View {
    var authState: AuthState
    var body: some View {
        Group {
            switch authState {
            case .loading:
                ProgressView()
            case .authenticated:
                ContainerTabView()
                    .preferredColorScheme(.dark)
            case .unauthenticated:
                LoginView()
            }
        }
    }
}
