//
//  LoginViewContoller.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/16.
//

import UIKit
import Combine

final class LoginViewController: UIViewController {
    private let auth = AuthViewModel()
    private let input: PassthroughSubject<AuthViewModel.Input, Never> = .init()
    private var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let output = auth.transform(input: input.eraseToAnyPublisher())
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                switch output {
                case .signState(let type):
                    if type == .signIn {
                        self?.showMainViewController()
                    }
                case .signInResult(let error):
                    if let error { self?.alert(msg: error) }
                    else { self?.showMainViewController() }
                case .isRunningAuth(let state):
                    //activity indicator = state
                    print(state)
                }
            }.store(in: &bag)
        input.send(.viewApear)
    }
    
    private func showMainViewController() {
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            alert(msg: "Failed move the Main")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navigation = UINavigationController(rootViewController: vc)
        
        delegate.window?.rootViewController = navigation
        delegate.window?.makeKeyAndVisible()
    }
    private func alert(msg: String) {
        let alert = UIAlertController(title: "Error",
                                      message: msg,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func SignInWithAppleButtonTapped(_ sender: UIButton) {
        input.send(.signInWithApple)
    }
    @IBAction func signInWithGoogleButtonTapped(_ sender: Any) {
        input.send(.signInWithGoogle)
    }
}
