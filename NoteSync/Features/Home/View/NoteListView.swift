//
//  NoteListView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI


struct NoteListView: View {
    @EnvironmentObject var router: Router
    @StateObject private var notificationService = NotificationService()
    @StateObject var noteListVM: NoteListViewModel
    init(userId: String) {
        _noteListVM = StateObject(wrappedValue: NoteListViewModel(userId: userId))
    }
    
    var body: some View {
        Group {
            if noteListVM.isInitialLoading {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(0..<5, id: \.self) { _ in
                            NoteSkeletonCardView()
                                .padding(.horizontal)
                        }
                    }
                }
            } else if noteListVM.notes.count >= 1 {
                ScrollView {
                    LazyVStack(spacing: 15){
                        ForEach(noteListVM.filterNoteWithSearch) { note in
                            CardNoteListView(
                                title: note.title,
                                noteDescription: note.body,
                                tag: ["Swift", "Firebase", "Firestore"],
                                searchText: noteListVM.searchNote,
                                lastUpdate: note.lastUpdateLocal
                            )
                            .onTapGesture {
                                router.navigate(to: .noteEditorView(noteModel: note, userId: noteListVM.userId))
                            }
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
                        router.navigate(to: .noteEditorView(noteModel: NoteModel(title: "", body: "", ownerId: noteListVM.userId), userId: noteListVM.userId))
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Welcome Budi")
        .searchable(text: $noteListVM.searchNote)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.nsBackground)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.navigate(to: .noteEditorView(noteModel: NoteModel(title: "", body: "", ownerId: noteListVM.userId), userId: noteListVM.userId))
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

private struct NoteSkeletonCardView: View {
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.nsBorder.opacity(0.6))
                .frame(width: 180, height: 24)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.nsBorder.opacity(0.5))
                .frame(height: 16)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.nsBorder.opacity(0.5))
                .frame(width: 220, height: 16)
            
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.nsBorder.opacity(0.5))
                    .frame(width: 60, height: 24)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.nsBorder.opacity(0.5))
                    .frame(width: 80, height: 24)
            }
            
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.nsBorder.opacity(0.4))
                .frame(height: 1)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.nsBorder.opacity(0.5))
                .frame(width: 150, height: 14)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.nsCardSurface)
        )
        .overlay {
            GeometryReader { geometry in
                LinearGradient(
                    colors: [.clear, .white.opacity(0.15), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(15))
                .offset(x: animate ? geometry.size.width : -geometry.size.width)
            }
            .clipped()
            .allowsHitTesting(false)
        }
        .onAppear {
            withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) {
                animate = true
            }
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
