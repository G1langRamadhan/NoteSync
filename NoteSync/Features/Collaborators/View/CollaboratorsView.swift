//
//  CollaboratorsView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsView: View {
    @StateObject var collaboratorViewModel: CollaboratorsViewModel
    @StateObject var invitationViewModel: InvitationViewModel
    @State var email: String = ""
    var noteTitle: String
    
    init(noteModel: NoteModel, userId: String, userDetail: AuthDataResultModel?) {
        _collaboratorViewModel = StateObject(wrappedValue: CollaboratorsViewModel(userId: userId, note: noteModel, userInfo: userDetail))
        _invitationViewModel = StateObject(wrappedValue: InvitationViewModel(userInfo: userDetail))
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
                            await invitationViewModel.acceptInvitation(invitation: invitation)
                        },
                        onDecline: {
                            await invitationViewModel.declineInvitation(invitation: invitation)
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
