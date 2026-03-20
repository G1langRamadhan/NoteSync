//
//  AuthSevice.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 12/03/26.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

struct UserDB {
    var id: String
    var email: String?
    var photoURL: String?
    var dateCreated = Date()
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

class FirebaseAuthService: AuthServiceProtocol {
    var currentUser: AuthDataResultModel? {
        Auth.auth().currentUser.map { user in
            AuthDataResultModel(user: user)
        }
    }
    
    private var db = Firestore.firestore()
    
    private var userCollection: CollectionReference {
        db.collection("users")
    }
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    func createUserDb(_ user: UserDB) async throws {
        let data: [String: Any] = [
            "id" : user.id,
            "email" : user.email ?? "",
            "photoUrl" : user.photoURL ?? "",
            "dateCreated" : user.dateCreated
        ]
        try await userCollection.document(user.id).setData(data)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            try await createUserDb(UserDB(user: authDataResult.user))
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
        
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResultModel {
        do {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            try await createUserDb(UserDB(user: authDataResult.user))
            return AuthDataResultModel(user: authDataResult.user)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
       
    }
    
    func signInWithGoogle(googleToken: googleDataResult) async throws -> AuthDataResultModel {
        do {
            let authDataResult = GoogleAuthProvider.credential(withIDToken: googleToken.tokenId, accessToken: googleToken.accessToken)
            return try await sigIn(credential: authDataResult)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
        
    }
    
    func signInWithApple(appleDataResult: AppleDataResult) async throws -> AuthDataResultModel {
        do {
            let authDataResult =  OAuthProvider.appleCredential(
                withIDToken: appleDataResult.tokenId,
                rawNonce: appleDataResult.rawNonce,
                fullName: appleDataResult.fullName
            )
            return try await sigIn(credential: authDataResult)
        } catch {
            throw AuthError.unknown(error.localizedDescription)
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            throw AuthError.unknown(error.localizedDescription)
        }
    }
    
    func sigIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let dataResult = try await Auth.auth().signIn(with: credential)
        try await createUserDb(UserDB(user: dataResult.user))
        return AuthDataResultModel(user: dataResult.user)
    }
    
    func observeAuthState(onChange: @escaping (AuthDataResultModel?) -> Void) {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
        
        authListener = Auth.auth().addStateDidChangeListener({ _, user in
            onChange(user.map{ AuthDataResultModel(user: $0) })
        })
    }
    
    private func mapFirebaseError(_ error: NSError) -> AuthError {
        let code = AuthErrorCode(rawValue: error.code)
        switch code {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .wrongPassword
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .networkError:
            return .networkError
        default:
            return .unknown(error.localizedDescription)
        }
    }
    
    deinit {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}

