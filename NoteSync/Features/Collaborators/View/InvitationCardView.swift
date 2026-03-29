//
//  InvitationCardView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 29/03/26.
//

import SwiftUI

struct InvitationCardView: View {
    let invitation: InvitationModel
    let onAccept: () async -> Void
    let onDecline: () async -> Void
    
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(invitation.title)
                        .font(.system(size: 15))
                        .foregroundColor(.nsTextPrimary)
                        .lineLimit(1)
                    
                    Text("Dari \(invitation.invitationFrom)")
                        .font(.system(size: 13))
                        .foregroundColor(.nsTextSecondary)
                }
                
                Spacer()
                
                RoleBadgeView(role: invitation.role)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 11))
                Text("Berlaku hingga \(invitation.expiresAt.formatted(.dateTime.day().month(.abbreviated)))")
                    .font(.system(size: 11))
            }
            .foregroundColor(.nsTextSecondary)
            
            HStack(spacing: 10) {
                
                // Decline
                Button {
                    Task {
                        do {
                            await onDecline()
                        }
                    }
                } label: {
                    Text("Tolak")
                        .font(.system(size: 14))
                        .foregroundColor(.nsTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.nsBackground)
                        .cornerRadius(10)
                }
                .disabled(isLoading)
                
                // Accept
                Button {
                    Task {
                        do {
                            isLoading = true
                            await onAccept()
                            isLoading = false
                        }
                    }
                } label: {
                    Group {
                        if isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Terima")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.nsAccentSecondary)
                    .cornerRadius(10)
                }
                .disabled(isLoading)
            }
        }
        .padding(16)
        .background(Color.nsCardSurface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentYellow, lineWidth: 1)
        )
    }
}

struct RoleBadgeView: View {
    let role: Role
    
    private var color: Color {
        switch role {
        case .editor: return .nsAccentPrimary
        case .viewer: return .blue
        }
    }
    
    var body: some View {
        Text(role.displayText)
            .font(.system(size: 11))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .cornerRadius(20)
    }
}

#Preview {
    let dummyInvitation = InvitationModel(
        noteId: "note_12345",
        title: "Project Planning Notes",
        role: .editor,
        invitationFrom: "user_67890",
        toEmail: "testuser@example.com"
    )
    InvitationCardView(
        invitation: dummyInvitation,
        onAccept:{
            
        } ,onDecline: {
            
        })
}
