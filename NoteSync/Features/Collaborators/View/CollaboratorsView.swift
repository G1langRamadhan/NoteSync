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
    var footer: String {
        if selectedRole == .viewer {
            return "Viewer hanya dapat melihat"
        }
        
        return "Collaborator dapat mengedit dan melihat"
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Invite Collaborator")
                            .foregroundStyle(Color.white)
                    }
                    .font(.headline)
                    
                    Text("Tambahkan orang lain untuk kolaborasi di note ini")
                        .font(.subheadline)
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email Kolaborator")
                            .foregroundStyle(.textSecondary)
                            .font(.footnote)
                        TextField("Email kolaborator", text: $email)
                            .foregroundStyle(Color.nsTextPrimary)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                            .padding(.leading, 8)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.border)
                                    .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .email ? 1.5 : 0)
                            )
                        Text("Pastikan Email Sudah Benar")
                            .foregroundStyle(.textSecondary)
                            .font(.footnote)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Peran")
                            .foregroundStyle(.textSecondary)
                            .font(.footnote)
                        
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
                                Image(systemName: "person")
                                Text(selectedRole.displayText)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.nsTextPrimary)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.border)
                            )
                        }
                        
                        Text(footer)
                            .font(.footnote)
                            .foregroundStyle(.textSecondary)
                        
                        Button {
                            Task {
                                do {
                                    try await sendInvitationViewModel.sendInvitation(to: email, role: selectedRole)
                                    email = ""
                                }
                            }
                        } label: {
                            Text("Kirim Undangan")
                                .fontWeight(.semibold)
                                .foregroundStyle(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                                 || sendInvitationViewModel.isSending ? .textSecondary : .black)
                                .frame(maxWidth: .infinity)
                                .padding(14)
                                .background(
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                              || sendInvitationViewModel.isSending ? Color.border : Color.nsAccentSecondary )
                                )
                                .padding(.top, 10)
                        }
                        .disabled(
                            email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            || sendInvitationViewModel.isSending
                        )

                    }
                    
                }
                .padding(.vertical, 22)
                .padding(.horizontal, 16)
                .background {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.nsCardSurface.opacity(0.7))
                }

//                if !collaboratorViewModel.collaborators.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "person.2")
                            Text("Collaborators")
                            
                            Spacer()
                            Text("\(collaboratorViewModel.collaborators.count)")
                        }
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        
                        Divider()
                        
                        Text("Kolaborator Terkonfirmasi")
                            .font(.footnote)
                            .foregroundStyle(.textSecondary)
                        ForEach(collaboratorViewModel.collaborators) { collaborator in
                            CollaboratorsCardView(
                                collaboratorId: collaborator.id,
                                name: collaborator.name,
                                photoUrl: collaborator.photoProfile,
                                collaboratorRoles: collaborator.role,
                            )
                            .padding(12)
//                            .background(Color.nsCardSurface)
//                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .onTapGesture {
                                selectedCollaborator = collaborator // ← trigger sheet dari parent
                            }
                        }
                        
                        Divider()
                        
                        Text("Undangan Terkirim (Pending)")
                            .font(.footnote)
                            .foregroundStyle(.textSecondary)
                        
                    }
                    .padding(.vertical, 22)
                    .padding(.horizontal, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 22)
                            .fill(Color.nsCardSurface.opacity(0.7))
                    }
//                }
                
                if let invitation = sendInvitationViewModel.pendingInvitations.first {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.line.dotted.person")
                            Text("Pending Invitation")
                            
                            Spacer()
                            Button {
                                
                            } label: {
                                HStack {
                                    Text("View All")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.callout)
                                .foregroundStyle(.orangePrimary)
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        
                        InvitationCardView(
                            invitation: invitation,
                            onAccept: {
//                                await invitationViewModel.acceptInvitation(invitation: invitation)
                            },
                            onDecline: {
//                                await invitationViewModel.declineInvitation(invitation: invitation)
                            }
                        )
                        
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cardSurface)
                    )
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

#Preview {
    let note = NoteModel(title: "gilang", body: "example body text", ownerId: "test user")
    NavigationStack {
        CollaboratorsView(noteModel: note, userId: "example", userDetail: nil)
    }
}
