//
//  ProfileViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject var invitationViewModel: InvitationInboxViewModel
    @StateObject var noteListVM: NoteListViewModel
    init(userId: String) {
        _noteListVM = StateObject(wrappedValue: NoteListViewModel(userId: userId))
        _invitationViewModel = StateObject(wrappedValue: InvitationInboxViewModel(userId: userId, userInfo: nil))
    }
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Button {
                    print("Change photo profile")
                } label: {
                    UserAvatarView(photoUrl: authViewModel.currentUser?.photoURL, displayName: authViewModel.currentUser?.name, size: 100)
                }
                .buttonStyle(.plain)
                
                VStack(spacing: 5) {
                    Text(authViewModel.currentUser?.name ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(authViewModel.currentUser?.email ?? "")
                        .foregroundStyle(Color.nsTextSecondary)
                }
                
                HStack {
                    noteCard(value: noteListVM.myNotes.count, title: "Notes Created")
                    
                    Spacer()
                    
                    noteCard(value: noteListVM.sharedNotes.count, title: "Notes Shared")
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(
                        title: "Undangan Masuk",
                        count: invitationViewModel.invitations.count
                    )
                    
                    ForEach(invitationViewModel.invitations) { invitation in
                        InvitationCardView(
                            invitation: invitation,
                            onAccept: {
                                await invitationViewModel.acceptInvitation(invitation: invitation)
                            },
                            onDecline: {
                                await invitationViewModel.declineInvitation(invitation: invitation)
                            }
                        )
                    }
                    
                }
            }
            
            VStack(spacing: 20) {
                ForEach(ProfileTabType.allCases) {type in
                    ProfileRow(
                        profileTabType: type,
                        editProfileAction: {
                            print("Edit profile tapped")
                        },
                        collaboratorsInfoAction: {
                            print("Collaborators info tapped")
                        },
                        notificationsAction: {
                            print("Notifications tapped")
                        },
                        logoutAction: {
                            do {
                                try authViewModel.signOut()
                            } catch {
                                print("Sign out failed: \(error.localizedDescription)")
                            }
                        }
                    )
                }
            }
            .font(.title3)
            .foregroundStyle(Color.white)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.nsCardSurface)
            )
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "tray.badge")
                }
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.nsBackground)
        .onAppear {
            invitationViewModel.updateUserInfo(authViewModel.currentUser)
        }
    }
    
    func noteCard(value: Int, title: String) -> some View {
        VStack(spacing: 10) {
            Text("\(value)")
                .foregroundStyle(Color.orange)
            
            Text(title)
                .foregroundStyle(Color.text)
        }
        .padding()
        .font(.headline)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.border)
        )
        .padding()
    }
}


#Preview {
    ProfileView(userId: "")
        .environmentObject(AuthViewModel())
}
