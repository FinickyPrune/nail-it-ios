//
//  SingInViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import UIKit
import ProgressHUD

class SignInViewController: UIViewController {
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var signInButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let failMessage = "Log In Failed"
    
    var viewModel: SignInViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 5
        
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
    
    @IBAction func textFieldCompleteEditing(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.view.endEditing(true)
        if (loginTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            presentFailAlert(with: "Please, fill all fields.")
        } else {
            ProgressHUD.show()
            self.viewModel?.performLogin(login: loginTextField.text!,
                                         password: passwordTextField.text!) { message in
                DispatchQueue.main.async { [self] in
                    ProgressHUD.dismiss()
                    if message != nil {
                        presentFailAlert(with: message!)
                    } 
                }
            }
        }
    }
    
    @IBAction func singUpButtonPressed(_ sender: Any?) {
        self.view.endEditing(true)
        viewModel?.didTapSingUp()
    }
    
    private func presentFailAlert(with message: String) {
        let alertController = UIAlertController(title: failMessage, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
}
