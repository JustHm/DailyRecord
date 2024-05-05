//
//  GoogleAuthService.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/07/15.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

enum AuthError: Error {
    case failure
    case success
}
protocol GoogleAuthService {
    func signInWithGoogle() async -> Result<AuthCredential, Error>
}

final class DefaultGoogleAuthService: GoogleAuthService {
    @MainActor //구글 로그인 실행
    func signInWithGoogle() async -> Result<AuthCredential, Error> {
        do {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return .failure(AuthError.failure)
            }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            guard let viewController = getCurrentViewController() else {
                return .failure(AuthError.failure)
            }
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            let user = userAuthentication.user
            
            guard let idToken = user.idToken else {
                return .failure(AuthError.failure)
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            return .success(credential)
        } catch {
            return .failure(error)
        }
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
}
