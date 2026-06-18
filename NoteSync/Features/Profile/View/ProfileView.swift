//
//  ProfileViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct informationProfile {
    var title: String
    var icon: String
    var iconColor: Color
    var number: Int
}

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @EnvironmentObject private var router: Router
    @StateObject var invitationViewModel: InvitationInboxViewModel
    @StateObject var noteListVM: NoteListViewModel
    init(userId: String) {
        _noteListVM = StateObject(wrappedValue: NoteListViewModel(userId: userId))
        _invitationViewModel = StateObject(wrappedValue: InvitationInboxViewModel(userId: userId, userInfo: nil))
    }
    
    // Init khusus Preview
    init(previewNoteVM: NoteListViewModel, previewInvitationVM: InvitationInboxViewModel) {
        _noteListVM = StateObject(wrappedValue: previewNoteVM)
        _invitationViewModel = StateObject(wrappedValue: previewInvitationVM)
    }
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
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
                        noteCard(
                            information: informationProfile(
                                title: "Total Notes",
                                icon: "list.bullet.clipboard",
                                iconColor: .accentOrange,
                                number: noteListVM.myNotes.count
                            )
                        )
                        noteCard(
                            information: informationProfile(
                                title: "Shared With Me",
                                icon: "person.2",
                                iconColor: .green,
                                number: noteListVM.myNotes.count
                            )
                        )
                        noteCard(
                            information: informationProfile(
                                title: "Note Shared",
                                icon: "list.bullet.clipboard",
                                iconColor: .blue,
                                number: noteListVM.sharedNotes.count
                            )
                        )
                    }
                }
                
                if let invitation = invitationViewModel.invitations.first {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "person.line.dotted.person")
                            Text("Invitation")
                            
                            Spacer()
                            Button {
                                router.navigate(to: RouteProfile.listInvitationView)
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
                                await invitationViewModel.acceptInvitation(invitation: invitation)
                            },
                            onDecline: {
                                await invitationViewModel.declineInvitation(invitation: invitation)
                            }
                        )
                        
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.cardSurface)
                    )
                }
                
                VStack(spacing: 10) {
                    ForEach(ProfileTabType.allCases) {type in
                        ProfileRow(profileTabType: type) {
                            switch type {
                            case .collaboratorsInfo:
                                router.navigate(to: RouteProfile.activeCollaboratorsView)
                                
                            case .notifications:
                                router.navigate(to: RouteProfile.notificationCenterView)
                                
                            case .setting:
                                router.navigate(to: RouteProfile.settingsView)
                                
                            case .logout:
                                isPresented = true
                            }
                        }
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
        }
        .alert("Sign Out", isPresented: $isPresented, actions: {
            Button("Sign Out", role: .destructive) {
                do {
                    try authViewModel.signOut()
                } catch {
                    print("Sign out failed: \(error.localizedDescription)")
                }
            }
            
            Button("Cancel", role: .cancel) {
                isPresented = false
            }
            .foregroundStyle(Color.white)
        }, message: {
            Text("Are you sure want to sign out?")
        })
        .padding(.horizontal)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.nsBackground)
        .onAppear {
            invitationViewModel.updateUserInfo(authViewModel.currentUser)
        }
    }
    
    func noteCard(information: informationProfile) -> some View {
        VStack(spacing: 10) {
            Image(systemName: information.icon)
                .foregroundStyle(information.iconColor)
            Text("\(information.number)")
                .foregroundStyle(Color.white)
            
            Text(information.title)
                .foregroundStyle(Color.text)
                .font(.caption)
                .lineLimit(1)
        }
        .padding(.vertical)
        .padding(.horizontal, 5)
        .font(.headline)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardSurface)
        )
    }
}

#Preview {
    NavigationStack {
        ProfileView(
            previewNoteVM: .previewFilled,
            previewInvitationVM: .preview
        )
        .environmentObject(Router())
        .environmentObject(AuthViewModel.preview)
    }
}

// InvitationInboxViewModel
extension InvitationInboxViewModel {
    static var preview: InvitationInboxViewModel {
        let vm = InvitationInboxViewModel(userId: "preview_user", userInfo: nil)
        vm.invitations = [
            InvitationModel(
                noteId: "note_001",
                title: "Project Meeting Notes",
                role: .viewer,
                invitationFrom: "john@example.com",
                toEmail: "user@example.com"
            ),
            InvitationModel(
                noteId: "note_002",
                title: "Design System Documentation",
                role: .editor,
                invitationFrom: "sarah@example.com",
                toEmail: "user@example.com"
            ),
            InvitationModel(
                noteId: "note_003",
                title: "Sprint Planning Q3",
                role: .viewer,
                invitationFrom: "alex@example.com",
                toEmail: "user@example.com"
            )
        ]
        return vm
    }
}

extension AuthViewModel {
    static var preview: AuthViewModel {
        let vm = AuthViewModel()
        // Set dummy user agar currentUser tidak nil
        vm.currentUser = AuthDataResultModel(id: "", email: "gILANG", name: "giLANG", photoURL: nil, phoneNumber: nil)
        return vm
    }
}
