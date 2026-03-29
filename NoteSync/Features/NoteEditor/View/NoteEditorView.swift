//
//  NoteEditorView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct NoteEditorView: View {
    @StateObject var noteEditorViewModel: NoteEditorViewModel
    @EnvironmentObject var router: Router
    @FocusState var isTitleFocused
    @FocusState var isBodyFocused
    init(note: NoteModel, userId: String) {
        _noteEditorViewModel = StateObject(wrappedValue: NoteEditorViewModel(notes: note, userId: userId))
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                TextField(noteEditorViewModel.note.title, text: $noteEditorViewModel.note.title, axis: .vertical)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.nsTextPrimary)
                    .textFieldStyle(.plain)
                    .focused($isTitleFocused)
                    .submitLabel(.next)
                    .onSubmit {
                        isBodyFocused = true
                    }
                    .padding(.horizontal, 20)
                
                HStack(spacing: 20) {
                    Text(noteEditorViewModel.formattedDate)
                        .font(.system(size: 13))
                        .foregroundColor(.nsTextSecondary)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Circle()
                            .frame(width: 10)
                            .foregroundStyle(noteEditorViewModel.syncStatusColor)
                    }
                }
                .padding(.bottom, 8)
                
                ZStack(alignment: .topLeading) {
                    if noteEditorViewModel.note.body.isEmpty {
                        Text("Mulai menulis...")
                            .font(.system(size: 16))
                            .foregroundColor(.nsTextSecondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                            .allowsHitTesting(false)
                    }
                    
                    TextEditor(text: $noteEditorViewModel.note.body)
                        .font(.system(size: 16))
                        .foregroundColor(.nsTextPrimary)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .focused($isBodyFocused)
                        .frame(minHeight: 400)
                        .padding(.horizontal, 16)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.navigate(to: .collaboratorView(noteModel: noteEditorViewModel.note, userId: noteEditorViewModel.userId))
                    } label: {
                        Image(systemName: "person.3")
                            .font(.system(size: 12))
                    }
                }
            })
            .autocorrectionDisabled()
        }
        .background(Color.nsBackground)
        .onTapGesture {
            isBodyFocused = true
        }
        .onAppear {
            if noteEditorViewModel.note.title.isEmpty {
                isTitleFocused = true
            } else {
                isBodyFocused = true
            }
        }
    }
}
#Preview {
    NavigationStack {
        NoteEditorView(note: NoteModel(title: "", body: ""), userId: "")
    }
}
