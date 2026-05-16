//
//  NoteListView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI


struct NoteListView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var authVieModel: AuthViewModel
    @StateObject private var notificationService = NotificationService()
    @StateObject var noteListVM: NoteListViewModel
    init(userId: String) {
        _noteListVM = StateObject(wrappedValue: NoteListViewModel(userId: userId))
    }
    var body: some View {
        if noteListVM.notes.count >= 1 {
            ScrollView {
                LazyVStack(spacing: 15){
                    ForEach(noteListVM.filterNoteWithSearch) { note in
                        CardNoteListView(
                            title: note.title,
                            noteDescription: note.body,
                            tag: ["Swift", "Firebase", "Firestore"],
                            searchText: noteListVM.searchNote
                        )
                        .onTapGesture {
                            router.navigate(to: .noteEditorView(noteModel: note, userId: authVieModel.currentUser?.id ?? ""))
                        }
                    }
                }
            }
            .navigationTitle("Welcome Budi")
            .searchable(text: $noteListVM.searchNote)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.nsBackground
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.navigate(to: .noteEditorView(noteModel: NoteModel(title: "", body: ""), userId: authVieModel.currentUser?.id ?? ""))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } else {
            VStack(spacing: 20) {
                Text("Belum Ada catatan")
                    .font(.title)
                    .fontDesign(.rounded)
                
                Text("Klik tombol + di bawah \n untuk mulai menulis".capitalized)
                
                AuthButtonComponent(title: "Catatan Baru") {
                    router.navigate(to: .noteEditorView(
                        noteModel: NoteModel(title: "", body: ""),
                        userId: authVieModel.currentUser?.id ?? "")
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        NoteListView(userId: "")
            .environmentObject(Router())
            .environmentObject(AuthViewModel())
    }
}
