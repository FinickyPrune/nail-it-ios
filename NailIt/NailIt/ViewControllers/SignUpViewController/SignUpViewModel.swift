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
        
        if !isPasswordsMatch(password, repeatPassword) || password.count < 6 {
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
        return number.count == 12 && number.starts(with: "+7") && numberContainsOnlyNumbers(input: number)
    }
    
    private func isPasswordsMatch(_ password: String, _ repeatPassword: String) -> Bool {
        return password == repeatPassword
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

    private func numberContainsOnlyNumbers(input: String) -> Bool {
        for (index, chr) in input.enumerated() {
            if index == 0 { continue }
            if !(chr >= "0" && chr <= "9") {
                return false
            }
        }
        return true
    }
}
