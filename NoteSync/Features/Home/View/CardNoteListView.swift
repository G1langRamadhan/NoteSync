//
//  CardNoteListView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CardNoteListView: View {
    var thumbnail: String?
    var title: String
    var noteDescription: String
    var tag: [String]
    var searchText: String
    var lastUpdate: Date
    var isPinNote: Bool = false
    let height = UIScreen.main.bounds.height
    var body: some View {
        VStack {
            if let thumbnail {
                Image(thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxHeight: height * 0.25)
                    .frame(maxWidth: .infinity)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 12,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 12
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(highlightedText(title: title, searchText: searchText))
                    .foregroundStyle(Color.nsTextPrimary)
                    .font(.title2)
                    .bold()
                
                Text(noteDescription)
                    .foregroundStyle(Color.text)
                    .lineLimit(2)
                    .truncationMode(.tail)
                
                HStack {
                    ForEach(tag, id: \.self) { tag in
                        Text(tag)
                            .foregroundStyle(Color.nsTextPrimary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.blue)
                            )
                    }
                }
                .padding(.top, 5)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 1)
                    .foregroundStyle(Color.border)
                    .padding(.top, 10)
                
                TimelineView(.periodic(from: .now, by: 60)) { _ in
                    HStack {
                        Text("Updated " + lastUpdate.timeAgo())
                            .font(.subheadline)
                            .foregroundStyle(Color.text)
                            .opacity(0.6)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: isPinNote ? "pin.fill" : "pin")
                                .foregroundStyle(.orangePrimary)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardSurface)
        )
        .padding(.horizontal)
    }
    
    func highlightedText(title: String, searchText: String) -> AttributedString {
        var atributedString = AttributedString(title)
        
        guard searchText.count >= 2 else {
            return atributedString
        }

        if let range = atributedString.range(of: searchText, options: .caseInsensitive) {
            atributedString[range].foregroundColor = .nsAccentPrimary
            atributedString[range].font = .title.bold()
        }
        
        return atributedString
    }
}

#Preview {
    CardNoteListView(
        title: "🚀 Card Note List",
        noteDescription: "This is a very long description that explains the note in detail aku hgarhegehgb",
        tag: ["#SwiftUI", "#Combine", "#iOS"],
        searchText: "Swift",
        lastUpdate: Date()
    )
}
