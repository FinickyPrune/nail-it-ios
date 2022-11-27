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

class User: NSObject, NSCoding {

    var nailItToken: String?
    var nailItRefreshToken: String?
    var username: String?
    var email: String?
    var birthday: String?
    var country: String?
    var city: String?

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
        coder.encode(username, forKey: "username")
        coder.encode(email, forKey: "email")
        coder.encode(birthday, forKey: "birthday")
        coder.encode(country, forKey: "country")
        coder.encode(city, forKey: "city")
    }

    required init?(coder: NSCoder) {
        nailItToken = coder.decodeObject(forKey: "nailit_token") as! String?
        nailItRefreshToken = coder.decodeObject(forKey: "nailit_refresh_token") as! String?
        username = coder.decodeObject(forKey: "username") as! String?
        email = coder.decodeObject(forKey: "email") as! String?
        birthday = coder.decodeObject(forKey: "birthday") as! String?
        country = coder.decodeObject(forKey: "country") as! String?
        city = coder.decodeObject(forKey: "city") as! String?
    }

}
