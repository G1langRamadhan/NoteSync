//
//  ProvileTabRow.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

enum ProfileTabType: String, CaseIterable, Identifiable {
    case collaboratorsInfo
    case notifications
    case setting
    case logout
    
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .collaboratorsInfo:
            return "person.2"
        case .notifications:
            return "bell.badge"
        case .setting:
            return "gear"
        case .logout:
            return "door.right.hand.open"
        }
    }
    
    var title: String {
        switch self {
        case .collaboratorsInfo:
            return "Active Collaborators"
        case .notifications:
            return "Notifications Center"
        case .setting:
            return "Settings"
        case .logout:
            return "Logout"
        }
    }
    
    var subtitle: String {
        switch self {
        case .collaboratorsInfo:
            return "See and manage your collaborations"
        case .notifications:
            return "Manage your notification preferences"
        case .setting:
            return "App reference and more"
        case .logout:
            return "Logout from your account"
        }
    }
}


struct ProfileRow: View {
    let profileTabType: ProfileTabType
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: profileTabType.icon)
                    .padding(.horizontal, 15)
                    .font(.headline)
                    .frame(width: 30)
                    .foregroundStyle(profileTabType.id == .logout ? Color.red : Color.white)
                VStack(alignment: .leading) {
                    Text(profileTabType.title)
                        .font(.headline)
                        .foregroundStyle(profileTabType.id == .logout ? Color.red : Color.white)
                    Text(profileTabType.subtitle)
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
                .padding(.leading, 10)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.callout)
            }
        }
        .buttonStyle(.plain) // Mencegah warna tombol default (biru) menimpa teks/ikon
        Divider()
    }
}

//#Preview {
//    ProfileRow(profileTabType: .collaboratorsInfo)
//}
