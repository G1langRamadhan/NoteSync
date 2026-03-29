//
//  ContainerTabView.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import SwiftUI

enum TabSelection {
    case noteListView
    case collaboratorsView
    case profileView
}

struct ContainerTabView: View {
    @State private var tabSelection: TabSelection = .noteListView
    @EnvironmentObject var authVieModel: AuthViewModel
    
    @StateObject private var router = Router()
    @StateObject private var collabRouter = Router()
    @StateObject private var profileRouter = Router()
    var body: some View {
        TabView(selection: $tabSelection) {
            Tab("Note", systemImage: "pencil.and.list.clipboard", value: TabSelection.noteListView) {
                NavigationStack(path: $router.path) {
                    NoteListView(userId: authVieModel.currentUser?.id ?? "")
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .noteEditorView(let noteModel, let userId):
                                NoteEditorView(note: noteModel, userId: userId)
                            case .collaboratorView(let noteModel, let userId):
                                CollaboratorsView(noteModel: noteModel, userId: userId, userDetail: authVieModel.currentUser)
                            }
                        }
                }
                .environmentObject(router)
            }
            
//            Tab("Collaborators", systemImage: "person.3", value: TabSelection.collaboratorsView) {
//                NavigationStack(path: $collabRouter.path) {
//                    CollaboratorsView()
//                }
//            }
            
            Tab("Profile", systemImage: "person.crop.circle", value: TabSelection.profileView) {
                NavigationStack(path: $profileRouter.path) {
                    ProfileView(userId: authVieModel.currentUser?.id ?? "")
                }
            }
        }
        .tint(Color.nsAccentSecondary)
    }
}

#Preview {
    ContainerTabView()
        .environmentObject(AuthViewModel())
}
