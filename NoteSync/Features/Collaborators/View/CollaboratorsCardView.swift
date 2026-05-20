//
//  CollaboratorsCardView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsCardView: View {
    var collaboratorId: String?
    var name: String?
    var photoUrl: String?
    var collaboratorRoles: RoleCollaborator
    var currentStatus: String = "Online"
    var body: some View {
        HStack(spacing: 15) {
            UserAvatarView(photoUrl: photoUrl, displayName: name, size: 52)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text(name ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.nsTextPrimary)
                }
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

struct EditCollaboratorSheet: View {
    let collaborator: CollaboratorModel
    let onSave: (String, RoleCollaborator) -> Void
    let onDelete: () -> Void
    
    @State private var editedName: String
    @State private var editedRole: RoleCollaborator
    @Environment(\.dismiss) private var dismiss

    init(collaborator: CollaboratorModel, onSave: @escaping (String, RoleCollaborator) -> Void, onDelete: @escaping () -> Void) {
        self.collaborator = collaborator
        self.onSave = onSave
        self.onDelete = onDelete
        _editedName = State(initialValue: collaborator.name)
        _editedRole = State(initialValue: collaborator.role)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Informasi Kolaborator") {
                    TextField("Nama", text: $editedName)
                    Picker("Role", selection: $editedRole) {
                        Text("Viewer").tag(RoleCollaborator.viewer)
                        Text("Editor").tag(RoleCollaborator.editor)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        
                    } label: {
                        Text("Hapus Kolaborator")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onSave(editedName.trimmingCharacters(in: .whitespacesAndNewlines), editedRole)
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                }
            }
        }
    }
}

#Preview {
    CollaboratorsCardView(
        collaboratorId: "collab-id",
        name: "",
        photoUrl: "",
        collaboratorRoles: .editor
    )
}
