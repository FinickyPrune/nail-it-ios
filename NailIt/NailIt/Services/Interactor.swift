//
//  Interactor.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

final class Interactor {

    static let shared = Interactor()

        private let userManager = UserManager.shared

    private let nailItProvider = NailItProvider()

    // MARK: - NailIt API Interaction

    func performUserRegistration(userInfo: RegistrationUserInfo,
                                 completion: @escaping (NailItRegistrationResult) -> Void) -> DataHandler? {
        return nailItProvider.performUserRegistration(userInfo) { result in
            guard let data = result.data else {
                completion(NailItRegistrationResult(message: result.error?.localizedDescription,
                                                       error: result.error,
                                                       handler: result.handler))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItSignUpResponse.self, from: data)

                if let error = result.error {
                    completion(NailItRegistrationResult(message: response.message,
                                                           error: error,
                                                           handler: result.handler))
                    return
                }

                self.userManager.updateUserWith(userInfo)
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItRegistrationResult(message: nil,
                                                       error: nil,
                                                       handler: result.handler))
            } catch {
                log.error(error.localizedDescription)
                completion(NailItRegistrationResult(message: error.localizedDescription,
                                                       error: error,
                                                       handler: result.handler))
            }

        } as? DataHandler
    }

    func performSignInWith(_ loginData: AuthenticationDataObject,
                           completion: @escaping (NailItSignInResult) -> Void) -> DataHandler? {
        return nailItProvider.performUserAuthentication(loginData: loginData) { result in
            guard let data = result.data else {
                completion(NailItSignInResult(message: result.error?.localizedDescription,
                                                 error: result.error,
                                                 handler: result.handler))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItSignInResponse.self, from: data)

                if let error = result.error {
                    completion(NailItSignInResult(message: response.message,
                                                     error: error,
                                                     handler: result.handler))
                    return
                }

                self.userManager.updateUserWith(response.username)
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItSignInResult(message: nil,
                                                 error: nil,
                                                 handler: result.handler))
            } catch {
                log.error(error.localizedDescription)
                completion(NailItSignInResult(message: error.localizedDescription,
                                                 error: error,
                                                 handler: result.handler))
            }
        } as? DataHandler
    }

    private func refreshToken(completion: @escaping (NailItRefreshTokenResult?) -> Void) -> DataHandler? {
        let token = userManager.token(for: .nailItRefresh)
        return nailItProvider.refreshToken(token) { result in
            log.info("Attempts to refresh Autotuned token. \(Date())")
            guard let data = result.data else {
                completion(NailItRefreshTokenResult(message: result.error?.localizedDescription,
                                                       error: result.error,
                                                       handler: result.handler))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItRefreshTokenResponse.self, from: data)

                if let error = result.error {
                    completion(NailItRefreshTokenResult(message: response.message,
                                                           error: error,
                                                           handler: result.handler))
                    return
                }

                log.info("Refreshed successfully.")
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItRefreshTokenResult(message: nil,
                                                       error: nil,
                                                       handler: result.handler))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItRefreshTokenResult(message: error.localizedDescription,
                                                       error: error,
                                                       handler: result.handler))
            }
        } as? DataHandler
    }

}
