//
//  SignInViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation

protocol SignInViewModelActionDelegate: AnyObject {
    func singInViewModelAttemptsToDismissController(_ viewModel: SignInViewModel)
    func singInViewModelAttemptsToShowSignUpController(_ viewModel: SignInViewModel)
}

class SignInViewModel {
    
    weak var actionDelegate: SignInViewModelActionDelegate?
        
    func performLogin(login: String,
                      password: String,
                      completion: @escaping (_: String?) -> Void) {
        
        if !isLoginValid(login) {
            completion("Login is incorrect.")
            return
        }
        
        if !isPasswordValid(password) {
            completion("Invalid credentials.")
            return
        }
        
        let loginData = AuthenticationDataObject(username: login, password: password)
        _ = Interactor.shared.performSignInWith(loginData) { result in
            if result.error != nil {
                completion(result.message)
                return
            }
            completion(nil)
            self.didLoginSuccessfully()
        }
    }
    
    private func isLoginValid (_ login: String) -> Bool {
        return true
    }
    
    private func isPasswordValid (_ password: String) -> Bool {
        return true
    }
    
    func didTapSingUp() {
        actionDelegate?.singInViewModelAttemptsToShowSignUpController(self)
    }
    
    func didLoginSuccessfully() {
        actionDelegate?.singInViewModelAttemptsToDismissController(self)
    }
}
