//
//  AuthUseCase.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/12.
//
import Foundation
import Combine
import FirebaseAuth

protocol AuthUseCase {
    func startSignInWithApple(credential: OAuthCredential) -> Future<Int, Error>
    func startSignInWithGoogle() -> Future<Int, Error>
}

class DefaultAuthUseCase: AuthUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func startSignInWithApple(credential: OAuthCredential)
    -> Future<Int, Error> {
        return authRepository.startSignInWithApple(credential: credential)
    }
    
    func startSignInWithGoogle() -> Future<Int, Error> {
        return authRepository.startSignInWithGoogle()
    }
}
