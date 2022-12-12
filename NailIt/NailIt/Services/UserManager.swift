//
//  UserManager.swift
//  Pods
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

final class UserManager {

    static let shared = UserManager()

    private var user = User()
    private let userDefaults: UserDefaults = UserDefaults.standard

    var isNailItSignedIn: Bool { user.nailItToken != nil }

    private init() {
        if let data = userDefaults.object(forKey: "user") as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? User {
                    self.user = user
                } else {
                    log.error("Cannot fetch user from user defaults")
                }
            } catch {
                log.error("Cannot fetch user from user defaults")
            }
        }
    }

    private func saveUser() {
        let encoded = try? NSKeyedArchiver.archivedData(withRootObject: self.user, requiringSecureCoding: false)

        userDefaults.set(encoded, forKey: "user")
        userDefaults.synchronize()
    }

    func updateUserWith(_ info: RegistrationUserInfo) {
        self.user.name = info.name
        self.user.phoneNumber = info.phoneNumber
        saveUser()
    }

    func updateUserWith(_ username: String?) {
        self.user.name = username
        saveUser()
    }

    func token(for type: TokenType) -> String? {
        switch type {
        case .nailIt:
            return user.nailItToken
        case .nailItRefresh:
            return user.nailItRefreshToken
        }
    }

    func changeToken(newToken: String?, tokenType: TokenType) {
        user.changeToken(newToken: newToken, tokenType: tokenType)
        saveUser()
    }

}
