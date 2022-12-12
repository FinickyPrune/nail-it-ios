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
        
    func performRegistration(name: String,
                             phoneNumber: String,
                             password: String,
                             repeatPassword: String,
                             completion: @escaping (_: String?) -> Void) {
        
        if !isNameValid(name) {
            completion("Пожалуйста, измените имя.")
            return
        }
        
        if !isPhoneNumberValid(phoneNumber) {
            completion("Пожалуйста, измените номер.")
        }
        
        if !isPasswordsMatch(password, repeatPassword) {
            completion("Пароли не совпадают.")
            return
        }
    
        let userInfo = RegistrationUserInfo(name: name,
                                            phoneNumber: phoneNumber,
                                            password: password)
         Interactor.shared.performUserRegistration(userInfo: userInfo) { result in
            if result.error != nil {
                completion(result.message)
                return
            }
            completion(nil)
            self.didRegisterSuccessfully()
        }
    }
    
    private func isNameValid(_ name: String) -> Bool {
        return (2...25).contains(name.count) && containsOnlyLetters(input: name)
    }
    
    private func isPhoneNumberValid(_ number: String) -> Bool {
        return (11...12).contains(number.count) // TODO: More validation
    }
    
    private func isPasswordsMatch(_ password: String, _ repeatPassword: String) -> Bool {
        return password == repeatPassword // TODO: Password validation
    }

    private func didRegisterSuccessfully() {
        actionDelegate?.signUpViewModelAttemptsToDismissController(self)
    }

    private func containsOnlyLetters(input: String) -> Bool {
        for chr in input {
            if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr >= "а" && chr <= "я") && !(chr >= "А" && chr <= "Я") {
                return false
            }
        }
        return true
    }
}
