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
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.nsBackground)
    }
}

struct UserAvatarView: View {
    var photoUrl: String?
    var displayName: String?
    var size: CGFloat
    
    var initials: String {
        guard let name = displayName, !name.isEmpty else { return "?"}
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        
        return String(name.prefix(1)).uppercased()
    }
    var body: some View {
        Group {
            if let urlString = photoUrl,
               !urlString.isEmpty,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        initialsView
                            .overlay(
                                Circle()
                                    .stroke(Color.accentOrange, lineWidth: 1)
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        initialsView
                    @unknown default:
                        initialsView
                    }
                }
            } else {
                initialsView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
    
    private var initialsView: some View {
        ZStack {
            Circle()
                .fill(Color.accentYellow)
//                .frame(width: 100)
            
            Text(initials)
                .font(.system(size: size * 0.38, weight: .bold))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    ProfileView(userId: "")
        .environmentObject(AuthViewModel())
}
