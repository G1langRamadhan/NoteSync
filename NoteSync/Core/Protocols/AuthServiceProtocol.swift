//
//  AuthServiceProtocol.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 16/03/26.
//

import Foundation

protocol AuthServiceProtocol {
    var currentUser: AuthDataResultModel? { get }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel
    func signInWithGoogle(googleToken: googleDataResult) async throws -> AuthDataResultModel
    func signInWithApple(appleDataResult: AppleDataResult) async throws -> AuthDataResultModel
    
    func signOut() throws
    func observeAuthState(onChange: @escaping @MainActor (AuthDataResultModel?) -> Void)
}
