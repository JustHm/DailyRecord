//
//  AuthService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//
import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

protocol AuthDelegate {
    func receiveCredentialInApple(credential: OAuthCredential?)
    func receiveCredentialInGoogle(credential: AuthCredential?)
}

enum AuthProvider {
    case apple, google
}

final class AuthService: NSObject {
    func requestAuth() async throws {
        Auth.auth().sign
    }
}
