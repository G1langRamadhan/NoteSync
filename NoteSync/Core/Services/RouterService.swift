//
//  RouterService.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 19/03/26.
//

import Foundation
import Combine
import SwiftUI

enum Route: Hashable {
    case noteEditorView(noteModel: NoteModel, userId: String)
    case collaboratorView(noteModel: NoteModel, userId: String)
}

enum RouteProfile: Hashable {
    case settingsView
    case activeCollaboratorsView
    case notificationCenterView
    case listInvitationView
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate<T: Hashable>(to route: T) {
        path.append(route)
    }
    
    func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
