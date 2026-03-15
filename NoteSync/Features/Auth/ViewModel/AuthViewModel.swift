//
//  AuthViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 12/03/26.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth


class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var passwordConfirmation: String = ""
    @Published var currentUser: User?
    let authService = AuthService()
    
    func createEmailAccount() async throws {
        try await authService.createUserWithEmail(email: email, password: password)
        email = ""
        password = ""
        fullName = ""
        passwordConfirmation = ""
    }
    
    func loginEmailAccount() async throws {
        try await authService.loginWithEmail(email: email, password: password)
        email = ""
        password = ""
    }
    
    func signInWithGoogle() async throws {
        let googleDataResult = try await GoogleSignInHelper().getGooglDataResult()
        try await authService.loginWithGoogle(googleToken: googleDataResult)
    }
    
    func sigInWithApple() async throws {
        let appleDataResult = try await AppleSigInHelper().signInWithApple()
        try await authService.loginWithApple(appleDataResult: appleDataResult)
    }
    
    func getLoginUser() {
        do {
            currentUser = try authService.getCurrentUser()
        } catch {
            print(error)
        }
    }
    
    func textBinding(field: Field) -> Binding<String> {
        switch field {
        case .email:
            return Binding {
                self.email
            } set: {
                self.email = $0
            }
        case .fullName:
            return Binding {
                self.fullName
            } set: {
                self.fullName = $0
            }
        case .password:
            return Binding {
                self.password
            } set: {
                self.password = $0
            }
        case .passwordConfirmation:
            return Binding {
                self.passwordConfirmation
            } set: {
                self.passwordConfirmation = $0
            }
        }
    }
}
