//
//  AuthRepository.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/12.
//
import Combine
import Foundation
import FirebaseAuth

protocol AuthRepository {
    func startSignInWithApple(credential: OAuthCredential) -> Future<Bool, Error>
    func startSignInWithGoogle() -> Future<Bool, Error>
}
