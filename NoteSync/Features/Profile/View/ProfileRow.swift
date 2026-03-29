//
//  ProvileTabRow.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import SwiftUI

enum ProfileTabType: String, CaseIterable, Identifiable {
    case note
    case collaborators
    case notification
    
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .note:
            return "pencil.and.list.clipboard"
        case .collaborators:
            return "person.2"
        case .notification:
            return "bell.badge"
        }
    }
    
    var title: String {
        switch self {
        case .note:
            return "Total Note"
        case .collaborators:
            return "Active Collaborators"
        case .notification:
            return "Notification"
        }
    }
}


struct ProfileRow: View {
    let profileTabType: ProfileTabType
    var value: String?
    var body: some View {
        
        HStack {
            Image(systemName: profileTabType.icon)
            
            Text(profileTabType.title)
                .foregroundStyle(Color.nsTextPrimary)
            
            Spacer()
            
            if let value {
                Text(value)
            }
        }
        Divider()
    }
}

#Preview {
    ProfileRow(profileTabType: .collaborators)
}
