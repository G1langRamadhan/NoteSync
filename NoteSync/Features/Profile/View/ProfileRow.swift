//
//  ProvileTabRow.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

enum ProfileTabType: String, CaseIterable, Identifiable {
    case editProfile
    case collaboratorsInfo
    case notifications
    case logout
    
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .editProfile:
            return "person"
        case .collaboratorsInfo:
            return "person.2"
        case .notifications:
            return "bell.badge"
        case .logout:
            return "door.right.hand.open"
        }
    }
    
    var title: String {
        switch self {
        case .editProfile:
            return "Edit profile"
        case .collaboratorsInfo:
            return "Active Collaborators"
        case .notifications:
            return "Notifications Center"
        case .logout:
            return "Logout"
        }
    }
}


struct ProfileRow: View {
    let profileTabType: ProfileTabType
    var editProfileAction: () -> Void
    var collaboratorsInfoAction: () -> Void
    var notificationsAction: () -> Void
    var logoutAction: () -> Void
    var body: some View {
        HStack {
            Image(systemName: profileTabType.icon)
            Text(profileTabType.title)
            
            Spacer()
            
            Image(systemName: "chevron.right")
        }
        Divider()
    }
}

//#Preview {
//    ProfileRow(profileTabType: .collaboratorsInfo)
//}
