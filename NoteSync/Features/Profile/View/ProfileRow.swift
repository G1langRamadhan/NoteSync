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
    
    var id: Self { self }
    
    var icon: String {
        switch self {
        case .note:
            return "person"
        case .collaborators:
            return "person.2"
        }
    }
    
    var title: String {
        switch self {
        case .note:
            return "Edit profile"
        case .collaborators:
            return "Active Collaborators"
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
