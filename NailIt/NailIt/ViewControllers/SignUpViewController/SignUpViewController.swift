//
//  SignUpViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 07.09.2022.
//

import UIKit
import ProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    private var isEdited = false
    
    var viewModel: SignUpViewModel?
    
    private let failMessage = "Ошибка регистрации"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.layer.cornerRadius = 15
        phoneNumberTextField.layer.cornerRadius = 15
        passwordTextField.layer.cornerRadius = 15
        repeatPasswordTextField.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        nameTextField.clipsToBounds = true
        phoneNumberTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        repeatPasswordTextField.clipsToBounds = true

        NotificationCenter.default.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        NotificationCenter.default.addObserver(self,
                                       selector: #selector(keyboardWillShow),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 55
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @IBAction func textFieldDidEdited(_ sender: Any) {
        isEdited = true
    }
    
    @IBAction func textFieldCompleteEditing(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func didTapSignUp() {
        self.view.endEditing(true)
        if  (nameTextField.text?.isEmpty)! || (phoneNumberTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! || (repeatPasswordTextField.text?.isEmpty)! {
            presentFailAlert(with: "Пожалуйста, заполните все поля.")
        } else {
            ProgressHUD.show()
            self.viewModel?.performRegistration(name: nameTextField.text!,
                                                phoneNumber: phoneNumberTextField.text!,
                                                password: passwordTextField.text!,
                                                repeatPassword: repeatPasswordTextField.text!) { message in
                DispatchQueue.main.async { [self] in
                    ProgressHUD.dismiss()
                    if message != nil {
                        presentFailAlert(with: message!)
                    }
                }
            }
        }
    }
    
    private func presentFailAlert(with message: String) {
        let alertController = UIAlertController(title: failMessage, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
}
