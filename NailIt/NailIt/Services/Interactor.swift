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
                                 completion: @escaping (NailItRegistrationResult) -> Void) {
        nailItProvider.performUserRegistration(userInfo) { result in
            guard let data = result.data else {
                completion(NailItRegistrationResult(message: result.error?.localizedDescription,
                                                       error: result.error))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItSignUpResponse.self, from: data)

                if let error = result.error {
                    completion(NailItRegistrationResult(message: response.message,
                                                           error: error))
                    return
                }

                self.userManager.updateUserWith(userInfo)
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItRegistrationResult(message: nil,
                                                       error: nil))
            } catch {
                log.error(error.localizedDescription)
                completion(NailItRegistrationResult(message: error.localizedDescription,
                                                       error: error))
            }

        }
    }

    func performSignInWith(_ loginData: AuthenticationDataObject,
                           completion: @escaping (NailItSignInResult) -> Void) {
        nailItProvider.performUserAuthentication(loginData: loginData) { result in
            guard let data = result.data else {
                completion(NailItSignInResult(message: result.error?.localizedDescription,
                                                 error: result.error))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItSignInResponse.self, from: data)

                if let error = result.error {
                    completion(NailItSignInResult(message: response.message,
                                                     error: error))
                    return
                }

                self.userManager.updateUserWith(response.username)
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItSignInResult(message: nil,
                                                 error: nil))
            } catch {
                log.error(error.localizedDescription)
                completion(NailItSignInResult(message: error.localizedDescription,
                                                 error: error))
            }
        }
    }

    private func refreshToken(completion: @escaping (NailItRefreshTokenResult) -> Void) {
        let token = userManager.token(for: .nailItRefresh)
        nailItProvider.refreshToken(token) { result in
            log.info("Attempts to refresh NailIt token. \(Date())")
            guard let data = result.data else {
                completion(NailItRefreshTokenResult(message: result.error?.localizedDescription,
                                                       error: result.error))
                return
            }
            do {
                let response = try JSONDecoder().decode(NailItRefreshTokenResponse.self, from: data)

                if let error = result.error {
                    completion(NailItRefreshTokenResult(message: response.message,
                                                           error: error))
                    return
                }

                log.info("Refreshed successfully.")
                self.userManager.changeToken(newToken: response.accessToken, tokenType: .nailIt)
                self.userManager.changeToken(newToken: response.refreshToken, tokenType: .nailItRefresh)
                completion(NailItRefreshTokenResult(message: nil,
                                                       error: nil))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItRefreshTokenResult(message: error.localizedDescription,
                                                       error: error))
            }
        }
    }

    func getSalonsList(completion: @escaping (NailItSalonsListResult) -> Void) {
        let token = userManager.token(for: .nailIt)
        nailItProvider.salonsList(token) { result in
            guard let data = result.data else {
                completion(NailItSalonsListResult(message: result.error?.localizedDescription,
                                                  error: result.error,
                                                  salons: nil))
                return
            }
            do {
                let response = try JSONDecoder().decode([Salon].self, from: data)

                if let error = result.error {
                    completion(NailItSalonsListResult(message: error.localizedDescription,
                                                      error: error,
                                                      salons: nil))
                    return
                }
                completion(NailItSalonsListResult(message: nil,
                                                  error: nil,
                                                  salons: response))
            } catch {
                log.error("\(error.localizedDescription) \(result)")
                completion(NailItSalonsListResult(message: error.localizedDescription,
                                                  error: error,
                                                  salons: nil))
            }
        }

    }

}
