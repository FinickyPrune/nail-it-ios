//
//  RootCoordinator.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation
import UIKit

class RootCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var viewModel: MainViewModel?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        pushMainController()
    }
    
    private func presentSignInController() {
        let viewController = SignInViewController.loadFromNib()
        let viewModel = SignInViewModel()
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .fullScreen
        navigationController.present(viewController, animated: true)
    }
    
    private func presentSignUpController() {
        let viewController = SignUpViewController.loadFromNib()
        let viewModel = SignUpViewModel()
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        guard let presentedViewController = navigationController.presentedViewController as? SignInViewController else { return }
        presentedViewController.present(viewController, animated: true)
    }
    
    private func pushMainController() {
        let viewController = MainViewController.loadFromNib()
        let viewModel = MainViewModel()
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
}

extension RootCoordinator: SignInViewModelActionDelegate {
        
    func singInViewModelAttemptsToShowSignUpController(_ viewModel: SignInViewModel) {
        presentSignUpController()
    }
    
    func singInViewModelAttemptsToDismissController(_ viewModel: SignInViewModel) {
        DispatchQueue.main.async {
            guard let viewController = self.navigationController.presentedViewController as? SignInViewController else { return }
            viewController.dismiss(animated: true)
        }
        self.viewModel?.didLoginSuccessfully()
    }
    
}

extension RootCoordinator: SignUpViewModelActionDelegate {
    
    func signUpViewModelAttemptsToDismissController(_ viewModel: SignUpViewModel) {
        DispatchQueue.main.async {
            guard let signInViewController = self.navigationController.presentedViewController as? SignInViewController,
                  let signUpViewController = signInViewController.presentedViewController as? SignUpViewController  else { return }
            signUpViewController.dismiss(animated: true) {
                signInViewController.dismiss(animated: false)
            }
        }
        self.viewModel?.didLoginSuccessfully()
    }
    
}

extension RootCoordinator: MainViewModelActionDelegate {
    
    func mainViewModelAttemptsToLogin(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        DispatchQueue.main.async { [self] in
            presentSignInController()
        }
    }

}
