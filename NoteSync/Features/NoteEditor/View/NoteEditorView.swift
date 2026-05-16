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
    @State private var showCollaborators: Bool = false
    init(note: NoteModel, userId: String, userInfo: AuthDataResultModel?) {
        _noteEditorViewModel = StateObject(wrappedValue: NoteEditorViewModel(notes: note, userId: userId))
        _collaboratorViewModel = StateObject(wrappedValue: CollaboratorsViewModel(userId: userId, note: note, userInfo: userInfo))
    }
    
    var isEditable: Bool {
        if noteEditorViewModel.note.ownerId == noteEditorViewModel.userId {
            return true
        }
        
        if let collaboratorRole = collaboratorViewModel.collaborators.first(where: {$0.id == noteEditorViewModel.userId}) {
            print("collaboratorRole: \(collaboratorRole)")
            return collaboratorRole.role == .editor
        }
        
        return (collaboratorViewModel.noteModel.sharedWith.first(where: { $0 == noteEditorViewModel.userId}) != nil)
    }
    
    var ownerInfo: (name: String, avatar: String) {
        if let ownerInfo = collaboratorViewModel.userInfo,
           let name = ownerInfo.name,
           let photoURL = ownerInfo.photoURL {
            return (name, photoURL)
        }
        
        return ("Pemilik", "")
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
                    
                    //                    HStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(noteEditorViewModel.syncStatusColor)
                    //                    }
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
                    //                        .disabled(!isEditable)
                    
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showCollaborators = true
                    } label: {
                        Image(systemName: "person.3")
                            .font(.system(size: 12))
                    }
                }
            })
            .autocorrectionDisabled()
        }
        .sheet(isPresented: $showCollaborators, content: {
            VStack(alignment: .leading, spacing: 20) {
                Text("Kolaborator Catatan Ini")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .foregroundStyle(Color.nsTextPrimary)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if noteEditorViewModel.note.ownerId == noteEditorViewModel.userId {
                            CollaboratorsCardView(
                                name: ownerInfo.name + "(kamu)",
                                photoUrl: ownerInfo.avatar,
                                collaboratorRoles: .editor,
                                currentStatus: "Pemilik · mengedit sekarang"
                            )
                        }
                        ForEach(collaboratorViewModel.collaborators) { collaborator in
                            CollaboratorsCardView(/*statusCollaborators: collaborator.status,*/ name: collaborator.name, photoUrl: collaborator.photoProfile, collaboratorRoles: collaborator.role)
                        }
                    }
                }
            }
            .padding()
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
        })
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
        NoteEditorView(note: NoteModel(title: "", body: ""), userId: "", userInfo: nil)
    }
}
