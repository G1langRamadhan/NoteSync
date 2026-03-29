//
//  ProfileViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject var noteListVM: NoteListViewModel
    init(userId: String) {
        _noteListVM = StateObject(wrappedValue: NoteListViewModel(userId: userId))
    }
    var body: some View {
        VStack(spacing: 50) {
            VStack(spacing: 20) {
                Button {
                    print("Change photo profile")
                } label: {
                    UserAvatarView(photoUrl: authViewModel.currentUser?.photoURL, displayName: authViewModel.currentUser?.name, size: 100)
                }
                .buttonStyle(.plain)
                
                Text(authViewModel.currentUser?.name ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(authViewModel.currentUser?.email ?? "")
                    .foregroundStyle(Color.nsTextSecondary)
            }
            .padding(.top, 30)
            
            VStack(spacing: 20) {
                ForEach(ProfileTabType.allCases) {type in
                    ProfileRow(profileTabType: type, value: String(noteListVM.notes.count))
                }
                
                Button {
                    try? authViewModel.logOut()
                } label: {
                    HStack {
                        Text("Keluar")
                            .foregroundStyle(Color.nsError)
                        
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .font(.title3)
            .foregroundStyle(Color.white)
            
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
    }
}


#Preview {
    ProfileView(userId: "")
        .environmentObject(AuthViewModel())
}
