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
    @Published var authState: AuthState = .loading
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var currentUser: AuthDataResultModel?
    private let authServiceProtocol: AuthServiceProtocol
    private let appleSignInHelperProtocol: AppleSigInHelperProtocol
    private let googleSignInHelperProtocol: GoogleSignInHelperProtocol
    
    init(
        authService: AuthServiceProtocol = FirebaseAuthService(),
        googleSignInHelper: GoogleSignInHelperProtocol = GoogleSignInHelper(),
        appleSignInHelper: AppleSigInHelperProtocol = AppleSigInHelper()
    ) {
        self.authServiceProtocol = authService
        self.googleSignInHelperProtocol = googleSignInHelper
        self.appleSignInHelperProtocol = appleSignInHelper
        observeAuthState()
    }
    
    @MainActor
    func observeAuthState() {
        authServiceProtocol.observeAuthState { [weak self] user in
            Task { @MainActor in
                self?.currentUser = user
                self?.authState = user != nil ? .authenticated : .unauthenticated
            }
        }
    }
    
    @MainActor
    func signOut() throws {
        do {
            try authServiceProtocol.signOut()
            currentUser = nil
            authState = .unauthenticated
        } catch {
            errorMessage = "Gagal keluar. Coba lagi."
        }
    }
    
    @MainActor
    func createEmailAccount() async throws {
        isLoading = true
        errorMessage = nil
        do {
            currentUser = try await authServiceProtocol.createUser(email: email, password: password)
            authState = .authenticated
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
    
    @MainActor
    func loginEmailAccount() async throws {
        isLoading = true
        errorMessage = nil
        do {
            currentUser = try await authServiceProtocol.signInWithEmail(email: email, password: password)
            authState = .authenticated
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
        email = ""
        password = ""
    }
    
    @MainActor
    func signInWithGoogle() async throws {
        isLoading = true
        errorMessage = nil
        do {
            let googleDataResult = try await googleSignInHelperProtocol.getGooglDataResult()
            currentUser = try await authServiceProtocol.signInWithGoogle(googleToken: googleDataResult)
            authState = .authenticated
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
    }
    
    @MainActor
    func sigInWithApple() async throws {
        isLoading = true
        errorMessage = nil
        do {
            let appleDataResult = try await appleSignInHelperProtocol.signInWithApple()
            currentUser =  try await authServiceProtocol.signInWithApple(appleDataResult: appleDataResult)
            authState = .authenticated
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Theres Somthing wrong, Try Again"
        }
        
        isLoading = false
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
