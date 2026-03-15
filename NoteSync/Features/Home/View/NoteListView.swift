//
//  NoteListView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct NoteListView: View {
    @StateObject var noteListVM = NoteListViewModel()
   
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Welcome \nBudi")
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 52)
                            .foregroundStyle(Color.nsAccentPrimary)
                        
                        Text("B".capitalized)
                            .foregroundStyle(Color.nsTextPrimary)
                            .font(.title).bold()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    ForEach(noteListVM.filterNoteWithSearch) { note in
                        CardNoteListView (
                            title: note.title,
                            noteDescription: note.noteDescription,
                            tag: note.tag,
                            searchText: noteListVM.searchNote
                        )
                    }
                }
                .searchable(text: $noteListVM.searchNote)
                
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        NoteListView()
    }
}
