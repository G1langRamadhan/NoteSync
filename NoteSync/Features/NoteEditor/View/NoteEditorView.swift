//
//  NoteEditorView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

struct NoteEditorView: View {
    @StateObject var noteEditorViewModel: NoteEditorViewModel
    @StateObject var collaboratorViewModel: CollaboratorsViewModel
    @EnvironmentObject var router: Router
    @FocusState var isTitleFocused
    @FocusState var isBodyFocused
    init(note: NoteModel, userId: String, userInfo _: AuthDataResultModel?) {
        _noteEditorViewModel = StateObject(wrappedValue: NoteEditorViewModel(notes: note, userId: userId))
        _collaboratorViewModel = StateObject(wrappedValue: CollaboratorsViewModel(note: note, userId: userId))
    }
    
    var isEditable: Bool {
        if noteEditorViewModel.note.ownerId == noteEditorViewModel.userId {
            return true
        }
        
        if let collaboratorRole = collaboratorViewModel.collaborators.first(where: { $0.id == noteEditorViewModel.userId }) {
            return collaboratorRole.role == .editor
        }
        
        return false
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
                    .disabled(!isEditable)
                
                HStack(spacing: 20) {
                    Text(noteEditorViewModel.formattedDate)
                        .font(.system(size: 13))
                        .foregroundColor(.nsTextSecondary)
                        .padding(.horizontal, 20)
                    
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(noteEditorViewModel.syncStatusColor)
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
                        .disabled(!isEditable)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        router.navigate(to: Route.collaboratorView(
                            noteModel: noteEditorViewModel.note,
                            userId: noteEditorViewModel.userId)
                        )
                    } label: {
                        Image(systemName: "person.3")
                            .font(.system(size: 12))
                    }
                }
            })
            .autocorrectionDisabled()
        }
        .onAppear{
            Task {
                try await collaboratorViewModel.fetchOwnerNote()
            }
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
        NoteEditorView(note: NoteModel(title: "", body: "", ownerId: ""), userId: "", userInfo: nil)
    }
}
