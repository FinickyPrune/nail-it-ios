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
                log.error(error.localizedDescription)
            }
        }
    }

    private func saveUser() {
        let encoded = try? NSKeyedArchiver.archivedData(withRootObject: self.user, requiringSecureCoding: false)

        userDefaults.set(encoded, forKey: "user")
        userDefaults.synchronize()
    }

    func updateUserWith(id: Int, name: String, phone: String, token: String) {
        self.user.id = id
        self.user.name = name
        self.user.phoneNumber = phone
        self.user.nailItToken = token
        saveUser()
    }

    func token(for type: TokenType) -> String? {
        switch type {
        case .nailIt:
            return user.nailItToken
        }
    }

    var id: Int? {  user.id }
    var username: String? { user.name }
    var phoneNumber: String? { user.phoneNumber }
}
