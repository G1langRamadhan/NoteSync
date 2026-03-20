//
//  ButtonAuthComponent.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI

struct AuthButtonComponent: View {
    var title: String
    var onAction: () async throws -> Void = { }
    var body: some View {
        Button {
            Task {
                try? await onAction()
            }
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color.black)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background (
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.nsAccentPrimary)
                )
        }

    }
}

struct SaveNote: View {
    var title: String
    var onAction: () -> Void = { }
    var body: some View {
        Button {
            onAction()
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color.nsTextPrimary)
                .padding()
                .background (
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.nsAccentPrimary)
                )
        }

    }
}

#Preview {
    SaveNote(title: "Save Note")
    AuthButtonComponent(title: "Login")
}
