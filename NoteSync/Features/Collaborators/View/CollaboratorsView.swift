//
//  CollaboratorsView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsView: View {
    @StateObject var collaboratorViewModel: CollaboratorsViewModel
    @StateObject var sendInvitationViewModel: SendInvitationViewModel
    @State var email: String = ""
    @State private var selectedRole: RoleCollaborator = .viewer
    @State private var selectedCollaborator: CollaboratorModel? = nil
    var noteTitle: String
    
    init(noteModel: NoteModel, userId: String, userDetail: AuthDataResultModel?) {
        _collaboratorViewModel = StateObject(wrappedValue: CollaboratorsViewModel(note: noteModel, userId: userId))
        _sendInvitationViewModel = StateObject(
            wrappedValue: SendInvitationViewModel(
                context: NoteInvitationContext(
                    noteId: noteModel.id,
                    noteTitle: noteModel.title,
                    ownerId: noteModel.ownerId
                ),
                currentUser: userDetail
            )
        )
        noteTitle = noteModel.title
    }
    @FocusState private var focusedField: Field?
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(noteTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.nsTextPrimary)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Invite via email".uppercased())
                        .font(.caption)
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    HStack(spacing: 10) {
                        TextField("Email kolaborator", text: $email)
                            .foregroundStyle(Color.nsTextPrimary)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                        
                        Menu {
                            Button {
                                selectedRole = .viewer
                            } label: {
                                Label("Viewer", systemImage: selectedRole == .viewer ? "checkmark" : "")
                            }
                            
                            Button {
                                selectedRole = .editor
                            } label: {
                                Label("Editor", systemImage: selectedRole == .editor ? "checkmark" : "")
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Text(selectedRole.displayText)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .foregroundStyle(Color.nsTextPrimary)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.nsCardSurface)
                            )
                        }
                        
                        Button {
                            Task {
                                do {
                                    try await sendInvitationViewModel.sendInvitation(to: email, role: selectedRole)
                                    email = ""
                                }
                            }
                        } label: {
                            Text("Kirim")
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.nsAccentSecondary)
                                .clipShape(Capsule())
                        }
                        .disabled(
                            email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            || sendInvitationViewModel.isSending
                        )
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.border)
                            .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .email ? 1.5 : 0)
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(
                        title: "Kolaborator Aktif",
                        count: collaboratorViewModel.collaborators.count
                    )
                    
                    ForEach(collaboratorViewModel.collaborators) { collaborator in
                        CollaboratorsCardView(
                            collaboratorId: collaborator.id,
                            name: collaborator.name,
                            photoUrl: collaborator.photoProfile,
                            collaboratorRoles: collaborator.role,
                        )
                        .padding(12)
                        .background(Color.nsCardSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                                selectedCollaborator = collaborator // ← trigger sheet dari parent
                            }
                    }
                }
            }
        }
        .sheet(item: $selectedCollaborator) { collaborator in
            EditCollaboratorSheet(
                collaborator: collaborator,
                onSave: { name, role in
                    var updated = collaborator
                    updated.name = name
                    updated.role = role
                    Task {
                        try await collaboratorViewModel.updateCollaborator(colloratorModel: updated)
                    }
                },
                onDelete: {
                    Task {
                        try await collaboratorViewModel.deleteCollaborator(collaboratorId: collaborator.id)
                    }
                }
            )
            .presentationDetents([.medium])
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .navigationTitle("Collaborators")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.nsBackground
        )
    }
}

struct SectionHeaderView: View {
    let title: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.nsTextSecondary)
            Spacer()
            Text("\(count)")
                .font(.system(size: 12))
                .foregroundColor(.nsTextSecondary)
        }
    }
}

//#Preview {
//    NavigationStack {
//        CollaboratorsView(noteTitle: "SwiftUI Roadmap")
//    }
//}
