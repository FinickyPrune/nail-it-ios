//
//  File.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 07.09.2022.
//

import Foundation

protocol SignUpViewModelActionDelegate: AnyObject {
    func signUpViewModelAttemptsToDismissController(_ viewModel: SignUpViewModel)
}

class SignUpViewModel {
    
    weak var actionDelegate: SignUpViewModelActionDelegate?
        
    func performRegistration(login: String,
                             email: String,
                             birth: String,
                             country: String, city: String,
                             height: String, heightUnits: String,
                             weight: String, weightUnits: String,
                             password: String, repeatPassword: String,
                             completion: @escaping (_: String?) -> Void) {
        
        if !isLoginValid(login) {
            completion("Please change your login.")
            return
        }
        
        if !isEmailValid(email) {
            completion("Please correct your email.")
        }
        
        if !isPasswordsMatch(password, repeatPassword) {
            completion("Passwords don't match")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY"
        guard let date = dateFormatter.date(from: birth),
              isBirthValid(date) else {
            completion("Change birth date")
            return
        }

        let userInfo = RegistrationUserInfo(username: login,
                                            email: email,
                                            birthDate: date,
                                            country: country, city: city,
                                            password: password)
        _ = Interactor.shared.performUserRegistration(userInfo: userInfo) { result in
            if result.error != nil {
                completion(result.message)
                return
            }
            completion(nil)
            self.didRegisterSuccessfully()
        }
    }
    
    private func isLoginValid(_ login: String) -> Bool {
        return true
    }
    
    private func isEmailValid(_ email: String) -> Bool {
        return true
    }
    
    private func isPasswordsMatch(_ password: String, _ repeatPassword: String) -> Bool {
        return password == repeatPassword
    }
    
    private func isBirthValid(_ birth: Date) -> Bool {
        return true
    }
        
    private func didRegisterSuccessfully() {
        actionDelegate?.signUpViewModelAttemptsToDismissController(self)
    }
}
