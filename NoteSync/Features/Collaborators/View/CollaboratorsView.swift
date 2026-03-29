//
//  CollaboratorsView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsView: View {
    @StateObject var collaboratorViewModel: CollaboratorsViewModel
    @State var email: String = ""
    var noteTitle: String
    
    init(noteModel: NoteModel, userId: String, userDetail: AuthDataResultModel?) {
        _collaboratorViewModel = StateObject(wrappedValue: CollaboratorsViewModel(userId: userId, note: noteModel, userInfo: userDetail))
        noteTitle = noteModel.title
    }
    @FocusState private var focusedField: Field?
    var body: some View {
            VStack(spacing: 50) {
                VStack(alignment: .leading, spacing: 50) {
                    Text(noteTitle)
                        .font(.title)
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Invite VIA EMAIL".uppercased())
                            .foregroundStyle(Color.nsTextSecondary)
                        
                        TextField("Email", text: $email)
                            .foregroundStyle(Color.nsTextPrimary)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.border)
                                    .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .email ? 2 : 0)
                            )
                            .focused($focusedField, equals: .email)
                        
                        Button {
                            Task {
                                do {
                                    try await collaboratorViewModel.sentInvitation(to: email)
                                }
                            }
                        } label: {
                            Text("send invitation")
                        }

                    }
                }
                
                    Section {
                        ForEach(collaboratorViewModel.invitations) { invitation in
                            InvitationCardView(
                                invitation: invitation,
                                onAccept: {
                                    await  collaboratorViewModel.acceptInvitation(invitation: invitation)
                                },
                                onDecline: {
                                    await collaboratorViewModel.declineInvitation(invitation: invitation)
                                }
                            )
                            .listRowInsets(EdgeInsets(
                                top: 6, leading: 16,
                                bottom: 6, trailing: 16
                            ))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    } header: {
                        SectionHeaderView(
                            title: "Undangan Masuk",
                            count: collaboratorViewModel.invitations.count
                        )
                    }
                
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Anggota (\(collaboratorViewModel.collaborators.count))")
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(collaboratorViewModel.collaborators) { collaborator in
                                CollaboratorsCardView(/*statusCollaborators: collaborator.status,*/ name: collaborator.name, photoUrl: collaborator.photoProfile, collaboratorRoles: collaborator.role)
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
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
