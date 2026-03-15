//
//  GoogleHelper.swift
//  NoteSync
//
//  Created by Gilang Ramadhan on 14/03/26.
//

import Foundation
import GoogleSignIn

struct googleDataResult {
    var tokenId: String
    var accessToken: String
}

extension UIApplication {
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}

struct GoogleSignInHelper {
    func getGooglDataResult() async throws-> googleDataResult {
        guard let rootVC = UIApplication.shared.rootViewController else {
            throw URLError(.badServerResponse)
        }
        
        let signInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let tokenId = signInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = signInResult.user.accessToken.tokenString
        
        return googleDataResult(tokenId: tokenId, accessToken: accessToken)
    }
}
