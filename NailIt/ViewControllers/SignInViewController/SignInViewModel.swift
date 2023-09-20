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
        
    func performLogin(phoneNumber: String,
                      password: String,
                      completion: @escaping (_: String?) -> Void) {

        let loginData = AuthenticationDataObject(phoneNumber: phoneNumber, password: password)
        Interactor.shared.performSignInWith(loginData) { result in
            if result.error != nil {
                completion(result.message)
                return
            }
            completion(nil)
            self.didLoginSuccessfully()
        }
    }

    func didTapSingUp() {
        actionDelegate?.singInViewModelAttemptsToShowSignUpController(self)
    }
    
    func didLoginSuccessfully() {
        actionDelegate?.singInViewModelAttemptsToDismissController(self)
    }
}
