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
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
