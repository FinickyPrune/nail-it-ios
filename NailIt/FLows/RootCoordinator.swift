//
//  RootCoordinator.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation
import UIKit

final class RootCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    var viewModel: SalonCatalogViewModel?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationController()
    }
    
    func start() {
        pushSalonCatalogController()
        if !UserManager.shared.isNailItSignedIn {
            presentSignInController()
        }

    }

    private func setupNavigationController() {
        navigationController.navigationBar.tintColor = NIAppearance.nailItBrownColor
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: NIAppearance.nailItBrownColor]
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: NIAppearance.nailItOrangeColor]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes, for: .normal)
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

    private func pushSalonCatalogController() {
        let viewController = SalonCatalogViewController.loadFromNib()
        let viewModel = SalonCatalogViewModel()
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }

    private func pushSalonController(for salon: Salon) {
        let viewController = SalonViewController.loadFromNib()
        let viewModel = SalonViewModel(salon: salon)
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }

    private func presentAccountViewController() {
        let viewController = AccountViewController.loadFromNib()
        let viewModel = AccountViewModel()
        viewModel.displayDelegate = viewController
        viewModel.actionDelegate = self
        viewController.viewModel = viewModel
        viewController.modalPresentationStyle = .pageSheet
        navigationController.present(viewController, animated: true)
    }

    private func pushAppointmentViewController(for service: Service, salon: Salon?) {
        if #available(iOS 16.0, *) {
            let viewController = AppointmentViewController.loadFromNib()
            let viewModel = AppointmentViewModel(service: service, salon: salon)
            viewModel.displayDelegate = viewController
            viewModel.actionDelegate = self
            viewController.viewModel = viewModel
            navigationController.pushViewController(viewController, animated: false)
        }
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
            signUpViewController.dismiss(animated: true)
        }
    }
    
}

extension RootCoordinator: SalonCatalogViewModelActionDelegate {

    func salonCatalogViewModelAttempsToDisplayAppointmentControllersStack(_ viewModel: SalonCatalogViewModel, for services: [Service]) {
        for service in services.reversed() {
            pushAppointmentViewController(for: service, salon: nil)
        }
    }

    func salonCatalogViewModelAttempsToDisplayAccountController(_ viewModel: SalonCatalogViewModel) {
        presentAccountViewController()
    }

    func salonCatalogViewModelAttempsToDisplaySalonController(_ viewModel: SalonCatalogViewModel, for salon: Salon) {
        pushSalonController(for: salon)
    }
}

extension RootCoordinator: SalonViewModelActionDelegate {

    func salonViewModelAttempsToDisplayAppointmnentController(_ viewModel: SalonViewModel, for service: Service, _ salon: Salon) {
        pushAppointmentViewController(for: service, salon: salon)
    }

    func salonViewModelAttempsToDisplayAccountController(_ viewModel: SalonViewModel) {
        presentAccountViewController()
    }

}

extension RootCoordinator: AccountViewModelActionDelegate {

}

@available(iOS 16.0, *)
extension RootCoordinator: AppointmentViewModelActionDelegate {

    func appointmentViewModelAttempsToDismissController(_ viewModel: AppointmentViewModel) {
        DispatchQueue.main.async {
            guard (self.navigationController.topViewController as? AppointmentViewController) != nil else { return }
            self.navigationController.popViewController(animated: true)
        }
    }

    func appointmentViewModelAttempsToDisplayAccountController(_ viewModel: AppointmentViewModel) {
        DispatchQueue.main.async {
            self.presentAccountViewController()
        }
    }

}
