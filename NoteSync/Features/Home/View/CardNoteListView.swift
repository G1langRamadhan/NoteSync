//
//  CardNoteListView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct CardNoteListView: View {
    var title: String
    var noteDescription: String
    var tag: [String]
    var searchText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(highlightedText(title: title, searchText: searchText))
                .font(.title)
                .bold()
            
            Text(noteDescription)
                .foregroundStyle(Color.nsTextSecondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.trailing, 100)
            
            HStack {
                ForEach(tag, id: \.self) { tag in
                    Text(tag)
                        .foregroundStyle(Color.nsTextPrimary)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.nsAccentSecondary)
                        )
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.nsCardSurface)
        )
    }
    
    func highlightedText(title: String, searchText: String) -> AttributedString {
        var atributedString = AttributedString(title)
        
        guard searchText.count > 3 else {
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
        noteDescription: "This is a very long description that explains the note in detail...",
        tag: ["#SwiftUI", "#Combine", "#iOS"],
        searchText: "Swift"
    )
}
