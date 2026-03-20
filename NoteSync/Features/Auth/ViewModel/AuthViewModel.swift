//
//  AuthViewModel.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 12/03/26.
//

import Foundation
import Combine
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullName: String = ""
    @Published var passwordConfirmation: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    @Published var currentUser: AuthDataResultModel?
    private let authServiceProtocol: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authServiceProtocol = authService
        observeAuthState()
    }
    
    func observeAuthState() {
        authServiceProtocol.observeAuthState { user in
            self.currentUser = user
            self.isAuthenticated = user != nil
        }
    }
    
    func logOut() throws {
        do {
            try authServiceProtocol.signOut()
        } catch {
            errorMessage = "Can't logOut"
        }
    }
    
    func createEmailAccount() async throws {
        isLoading = true
        errorMessage = nil
        do {
            currentUser = try await authServiceProtocol.createUser(email: email, password: password)
            isAuthenticated = true
        } catch let error as AuthError { // Tangkap error hanya jika tipe error tersebut adalah AuthError
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
        email = ""
        password = ""
        fullName = ""
        passwordConfirmation = ""
    }
    
    func loginEmailAccount() async throws {
        isLoading = true
        errorMessage = nil
        do {
            currentUser = try await authServiceProtocol.signInWithEmail(email: email, password: password)
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
        email = ""
        password = ""
    }
    
    func signInWithGoogle() async throws {
        isLoading = true
        errorMessage = nil
        do {
            let googleDataResult = try await GoogleSignInHelper().getGooglDataResult()
            currentUser = try await authServiceProtocol.signInWithGoogle(googleToken: googleDataResult)
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
    }
    
    func sigInWithApple() async throws {
        isLoading = true
        errorMessage = nil
        do {
            let appleDataResult = try await AppleSigInHelper().signInWithApple()
            currentUser =  try await authServiceProtocol.signInWithApple(appleDataResult: appleDataResult)
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try authServiceProtocol.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            errorMessage = "Gagal keluar. Coba lagi."
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
