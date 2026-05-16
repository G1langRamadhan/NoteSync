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
                    noteCard(value: noteListVM.filterNoteWithSearch.count, title: "Notes Created")
                    
                    Spacer()
                    
                    noteCard(value: noteListVM.filterNoteWithSearch.count, title: "Notes Shared")
                }
            }
            
            VStack(spacing: 20) {
                ForEach(ProfileTabType.allCases) {type in
                    ProfileRow(profileTabType: type, value: String(noteListVM.notes.count))
                }
                
                Button {

                } label: {
                    HStack {
                        Image(systemName: "bell.badge")
                        Text("Notifications Center")
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                }
                
                Divider()
                
                Button {
                    try? authViewModel.signOut()
                } label: {
                    HStack {
                        Image(systemName: "door.right.hand.open")
                        Text("Keluar")
                            .foregroundStyle(Color.nsError)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
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
