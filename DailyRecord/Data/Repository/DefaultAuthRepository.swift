//
//  DefaultAuthRepository.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/14.
//
import Combine
import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class DefaultAuthRepository {
    private let googleAuth: GoogleAuthService
    private let appleAuth: AppleAuthService
    
    init(googleAuth: GoogleAuthService, appleAuth: AppleAuthService) {
        self.googleAuth = googleAuth
        self.appleAuth = appleAuth
//        appleAuth.delegate = self
    }
}
extension DefaultAuthRepository: AuthRepository {
    func startSignInWithApple(credential: OAuthCredential) -> Future<Bool, Error> {
        return Future<Bool, Error> { promise in
            promise(.success(false))
        }
    }
    
    func startSignInWithGoogle() -> Future<Bool, Error> {
        return Future<Bool, Error> { promise in
            Task { [weak self] in
                do {
                    switch try await self?.googleAuth.signInWithGoogle() {
                    case .success(let credential):
                        try await Auth.auth().signIn(with: credential)
                        promise(.success(true))
                    case .failure(let error):
                        promise(.failure(error))
                    case .none:
                        promise(.success(false))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
