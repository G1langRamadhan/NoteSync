//
//  CollaboratorsCardView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsCardView: View {
    var statusCollaborators = "Editor"
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .frame(width: 52, height: 52)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Gilang Ramadhan")
                    .foregroundStyle(Color.nsTextPrimary)
                Text(statusCollaborators)
                    .foregroundStyle(Color.nsTextSecondary)
            }
            
            Spacer()
            
            Text("Online")
                .foregroundStyle(Color.green)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.nsCardSurface)
                )
        }

    }
}

#Preview {
    CollaboratorsCardView()
}
