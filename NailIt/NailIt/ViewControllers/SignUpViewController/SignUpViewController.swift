//
//  SignUpViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 07.09.2022.
//

import UIKit
import ProgressHUD

class SignUpViewController: UIViewController {
    
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var birthTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var cityTextField: UITextField!
    @IBOutlet private weak var heightTextField: UITextField!
    @IBOutlet private weak var heightUnitField: UITextField!
    @IBOutlet private weak var weightTextField: UITextField!
    @IBOutlet private weak var weightUnitField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet private weak var signUpButton: UIButton!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let birthPickerView = UIDatePicker()
    private let countryPickerView = UIPickerView()
    private let cityPickerView = UIPickerView()
    private let heightPickerView = UIPickerView()
    private let heightUnitPickerView = UIPickerView()
    private let weightUnitPickerView = UIPickerView()
    private let dateFormatter = DateFormatter()
    
    private var currentActivePicker: UIPickerView?
    private var keyboardToolbar: UIToolbar! {
        didSet {
            birthTextField.inputAccessoryView = keyboardToolbar
            countryTextField.inputAccessoryView = keyboardToolbar
            cityTextField.inputAccessoryView = keyboardToolbar
            heightTextField.inputAccessoryView = keyboardToolbar
            weightTextField.inputAccessoryView = keyboardToolbar
            heightUnitField.inputAccessoryView = keyboardToolbar
            weightUnitField.inputAccessoryView = keyboardToolbar
        }
    }
    
    private let maxHeightInFoots = 10
    private let maxHeightInCm = 300
 
    private var isEdited = false
    
    var viewModel: SignUpViewModel?
    
    private let failMessage = "Sign Up Failed"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 5
        setPickers()
        
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
    
    private func setPickers () {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        birthPickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            birthPickerView.preferredDatePickerStyle = .wheels
        }
        birthTextField.inputView = birthPickerView
 
        countryTextField.inputView = countryPickerView
        cityTextField.inputView = cityPickerView
        heightTextField.inputView = heightPickerView
        heightUnitField.inputView = heightUnitPickerView
        weightUnitField.inputView = weightUnitPickerView
    }
    
    @IBAction func didTapSignUp() {
        self.view.endEditing(true)
        if  (loginTextField.text?.isEmpty)! || (emailTextField.text?.isEmpty)! || (birthTextField.text?.isEmpty)! ||
                (countryTextField.text?.isEmpty)! || (cityTextField.text?.isEmpty)! ||
                (heightTextField.text?.isEmpty)! || (heightUnitField.text?.isEmpty)! ||
                (weightTextField.text?.isEmpty)! || (weightUnitField.text?.isEmpty)! ||
                (passwordTextField.text?.isEmpty)! || (repeatPasswordTextField.text?.isEmpty)! {
            presentFailAlert(with: "Please, fill all fields.")
        } else {
            ProgressHUD.show()
            self.viewModel?.performRegistration(login: loginTextField.text!,
                                                email: emailTextField.text!,
                                                birth: birthTextField.text!,
                                                country: countryTextField.text!, city: cityTextField.text!,
                                                height: heightTextField.text!, heightUnits: heightUnitField.text!,
                                                weight: weightTextField.text!, weightUnits: weightUnitField.text!,
                                                password: passwordTextField.text!, repeatPassword: repeatPasswordTextField.text!) { message in
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
