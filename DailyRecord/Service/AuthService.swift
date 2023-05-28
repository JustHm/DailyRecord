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
    var delegate: AuthDelegate?
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = CryptoUtil().randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = CryptoUtil().sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func startSignInWithGoogleFlow() {
        Task {
            await signInWithGoogle()
        }
    }
    
    @MainActor
    private func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        //구글 로그인 실행
        do {
            guard let viewController = getCurrentViewController() else { return }
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else { return }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            delegate?.receiveCredentialInGoogle(credential: credential)
        } catch {
            print(error.localizedDescription)
            delegate?.receiveCredentialInGoogle(credential: nil)
        }
    }
}

extension AuthService: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            delegate?.receiveCredentialInApple(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.receiveCredentialInApple(credential: nil)
    }
    
    private func getCurrentViewController() -> UIViewController? {
        //소셜 로그인 화면 띄우기 위한 VC 설정
        //'windows' was deprecated in iOS 15.0: Use UIWindowScene.windows on a relevant window scene instead
        //Scene에 접근할 때 원래쓰던 UIWindowScene.windows 방식은 곧 Deprecated 된다.
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let viewController = window?.rootViewController
        return viewController
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}
