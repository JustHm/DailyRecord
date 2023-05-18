//
//  AuthViewModel.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//
import Combine
import Foundation
import FirebaseAuth


final class AuthViewModel: NSObject {
    private var bag = Set<AnyCancellable>()
    private let output: PassthroughSubject<Output, Never> = .init()
    private let authService = AuthService()
    
    override init() {
        super.init()
        authService.delegate = self
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                switch input {
                case .viewApear:
                    self?.checkSignState()
                    break
                case .signInWithApple:
                    self?.authService.startSignInWithAppleFlow()
                case .signInWithGoogle:
                    self?.authService.startSignInWithGoogleFlow()
                }
            }
            .store(in: &bag)
        return output.eraseToAnyPublisher()
    }
    
    private func checkSignState() {
        guard let _ = Auth.auth().currentUser else {
            output.send(.signState(type: .signOut))
            return
        }
        output.send(.signState(type: .signIn))
    }
}

extension AuthViewModel: AuthDelegate {
    func receiveCredentialInApple(credential: OAuthCredential?) {
        guard let credential else {
            output.send(.signInResult(error: "Sign in Failed"))
            return
        }
        
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
            if let error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                self?.output.send(.signInResult(error: error.localizedDescription))
                return
            }
            self?.output.send(.signInResult(error: nil))
        }
    }
    
    func receiveCredentialInGoogle(credential: AuthCredential?) {
        guard let credential else {
            output.send(.signInResult(error: "Sign in Failed"))
            return
        }
        
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) {[weak self] (authResult, error) in
            if let error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                self?.output.send(.signInResult(error: error.localizedDescription))
                return
            }
            self?.output.send(.signInResult(error: nil))
        }
    }
}

extension AuthViewModel {
    enum SignState {
        case signIn, signOut
    }
    enum Input {
        case viewApear
        case signInWithApple
        case signInWithGoogle
    }
    enum Output {
        case signState(type: SignState)
        case signInResult(error: String?)
        case isRunningAuth(state: Bool)
    }
}
