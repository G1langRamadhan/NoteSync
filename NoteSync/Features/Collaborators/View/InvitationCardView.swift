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
        HStack(alignment: .top, spacing: 12) {
            UserAvatarView(displayName: invitation.invitationFrom, size: 30)
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(invitation.invitationFrom)")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)
                        
                        Text("Invite you to collaborate on")
                            .font(.system(size: 11))
                            .foregroundColor(.textSecondary)
                        
                        HStack {
                            Image(systemName: "folder")
                            Text(invitation.title)
                        }
                        .padding(.top, 5)
                        .foregroundColor(.accentYellow)
                        .font(.system(size: 11))
                    }
                    
                    Spacer()
                    
                    RoleBadgeView(role: invitation.role)
                    
                }
                
                
                HStack(spacing: 10) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 11))
                        Text("Berlaku hingga \(invitation.expiresAt.formatted(.dateTime.day().month(.abbreviated)))")
                            .font(.system(size: 11))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Button("Tolak") {
                            Task { await onDecline() }
                        }
                        .buttonStyle(InvitationButtonStyle(variant: .decline))
                        .disabled(isLoading)
                        
                        Button {
                            Task {
                                isLoading = true
                                await onAccept()
                                isLoading = false
                            }
                        } label: {
                            if isLoading {
                                ProgressView().tint(.black)
                            } else {
                                Text("Terima")
                            }
                        }
                        .buttonStyle(InvitationButtonStyle(variant: .accept))
                        .disabled(isLoading)
                    }
                    .layoutPriority(1)
                }
                .foregroundColor(.nsTextSecondary)
            }
        }
        .padding(14)
        .background(Color.nsBorder)
        .cornerRadius(12)
    }
}

struct InvitationButtonStyle: ButtonStyle {
    var variant: Variant
    
    enum Variant {
        case decline, accept
        
        var foregroundColor: Color {
            switch self {
            case .decline: return .primary
            case .accept:  return .black
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .decline: return Color.nsBackground
            case .accept:  return Color.nsAccentSecondary
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(variant.foregroundColor)
                .lineLimit(1)                              // ✅ Cegah text wrap
                .fixedSize(horizontal: true, vertical: false) // ✅ Lebar ikut konten
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(variant.backgroundColor)
                .cornerRadius(10)
                .opacity(configuration.isPressed ? 0.7 : 1)
        }
}

struct RoleBadgeView: View {
    let role: RoleCollaborator
    
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
