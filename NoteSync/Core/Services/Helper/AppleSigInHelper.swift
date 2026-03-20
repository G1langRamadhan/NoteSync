//
//  SingInWithAppleHelper.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 15/03/26.
//

import Foundation
import AuthenticationServices
import CryptoKit
import UIKit
import SwiftUI
import FirebaseAuth


struct AppleDataResult {
    var tokenId: String
    var rawNonce: String
    var fullName: PersonNameComponents
}

struct signInWithAppleButtonUIrepresentable: UIViewRepresentable {
    let buttonType: ASAuthorizationAppleIDButton.ButtonType
    let buttonStyle: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: buttonType, style: buttonStyle)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

extension UIViewController: @retroactive ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

final class AppleSigInHelper: NSObject {
    
    private var currentNonce: String?
    let authService = FirebaseAuthService()
    private var completionHandler: ((Result<AppleDataResult, Error>) -> Void)? = nil
    
    func signInWithApple() async throws -> AppleDataResult {
        return try await withCheckedThrowingContinuation { continuation in
            self.startSignInWithAppleFlow { result in
                switch result {
                case .success(let appleDataResult):
                    return continuation.resume(returning: appleDataResult)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func startSignInWithAppleFlow(completion: @escaping (Result<AppleDataResult, Error>) -> Void) {
        let nonce = randomNonceString()
        currentNonce = nonce
        completionHandler = completion
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = UIApplication.shared.rootViewController
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSigInHelper: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            return
        }
        
        
        let appleDataResult = AppleDataResult(
            tokenId: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName!
        )
        
        completionHandler?(.success(appleDataResult))
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
        print("Sign in with Apple errored: \(error)")
    }
    
}
