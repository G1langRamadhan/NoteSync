//
//  CollaboratorsView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CollaboratorsView: View {
    var noteTitle: String = "SwiftUI Roadmap"
    var totalCollaborators: Int = 0
    @State var email: String = ""
    @FocusState private var focusedField: Field?
    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                VStack(alignment: .leading, spacing: 50) {
                    Text(noteTitle)
                        .font(.title)
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Invite VIA EMAIL".uppercased())
                            .foregroundStyle(Color.nsTextSecondary)
                        
                        TextField("Email", text: $email)
                            .foregroundStyle(Color.nsTextPrimary)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.border)
                                    .stroke(Color.nsAccentPrimary, lineWidth: focusedField == .email ? 2 : 0)
                            )
                            .focused($focusedField, equals: .email)
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Anggota (\(totalCollaborators))")
                        .foregroundStyle(Color.nsTextSecondary)
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(0..<4) { index in
                                CollaboratorsCardView()
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Collaborators")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.nsBackground
            )
        }
    }
}

#Preview {
    NavigationStack {
        CollaboratorsView(noteTitle: "SwiftUI Roadmap")
    }
}
