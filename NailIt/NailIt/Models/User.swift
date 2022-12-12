//
//  User.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

enum TokenType {
    case nailIt
    case nailItRefresh
}

final class User: NSObject, NSCoding {

    var nailItToken: String?
    var nailItRefreshToken: String?
    var name: String?
    var phoneNumber: String?

    override init() {
        super.init()
    }

    func changeToken(newToken: String?, tokenType: TokenType) {
        switch tokenType {
        case .nailIt:
            nailItToken = newToken
        case .nailItRefresh:
            nailItRefreshToken = newToken
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(nailItToken, forKey: "nailit_token")
        coder.encode(nailItRefreshToken, forKey: "nailit_refresh_token")
        coder.encode(name, forKey: "name")
        coder.encode(phoneNumber, forKey: "phone_number")
    }

    required init?(coder: NSCoder) {
        nailItToken = coder.decodeObject(forKey: "nailit_token") as! String?
        nailItRefreshToken = coder.decodeObject(forKey: "nailit_refresh_token") as! String?
        name = coder.decodeObject(forKey: "name") as! String?
        phoneNumber = coder.decodeObject(forKey: "phone_number") as! String?
    }

}
