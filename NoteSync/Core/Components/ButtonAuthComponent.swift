//
//  ButtonAuthComponent.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 11/03/26.
//

import SwiftUI

struct ButtonAuthComponent: View {
    var title: String
    var onAction: () -> Void = { }
    var body: some View {
        Button {
            onAction()
        } label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundStyle(Color.nsTextPrimary)
//                .padding(.vertical)
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
    ButtonAuthComponent(title: "Login")
}
