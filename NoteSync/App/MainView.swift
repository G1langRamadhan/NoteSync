//
//  MainView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct MainView: View {
    var isAuthenticated: Bool
    var body: some View {
        Group {
            if isAuthenticated {
                ContainerTabView()
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    MainView(isAuthenticated: false)
}
