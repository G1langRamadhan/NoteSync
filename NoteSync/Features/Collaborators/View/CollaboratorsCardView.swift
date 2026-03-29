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
    var body: some View {
        HStack(spacing: 15) {
            UserAvatarView(photoUrl: photoUrl, displayName: name, size: 52)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name ?? "")
                    .foregroundStyle(Color.nsTextPrimary)
                Text("")
                    .foregroundStyle(Color.nsTextSecondary)
            }
            
            Spacer()
            
            Text(collaboratorRoles.rawValue.capitalized)
                .foregroundStyle(Color.nsAccentPrimary)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.nsCardSurface)
                )
        }

    }
}

#Preview {
    CollaboratorsCardView(
//        statusCollaborators: .offline,
        name: "",
        photoUrl: "",
        collaboratorRoles: .editor
    )
}
