//
//  CollaboratorsCardView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsCardView: View {
//    var statusCollaborators: CollaboratorStatus
    var name: String?
    var photoUrl: String?
    var collaboratorRoles: Role
    var currentStatus: String = "Online"
    var body: some View {
        HStack(spacing: 15) {
            UserAvatarView(photoUrl: photoUrl, displayName: name, size: 52)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.nsTextPrimary)
                Text(currentStatus)
                    .font(.caption)
                    .foregroundStyle(Color.nsTextSecondary)
            }
            
            Spacer()
            
            Text(collaboratorRoles.rawValue.capitalized)
                .foregroundStyle(Color.nsTextPrimary)
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.nsAccentSecondary)
                )
        }

    }
}

#Preview {
    CollaboratorsCardView(
//        statusCollaborators: .offline,
        name: "",
        photoUrl: "",
        collaboratorRoles: .editor,
    )
}
